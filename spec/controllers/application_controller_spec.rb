require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  let!(:user) { create(:user) }
  let(:headers) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }
  let(:invalid_headers) { { Authorization: nil } }

  describe '#authorize request' do
    context 'when auth token is sent' do
      before { allow(request).to receive(:headers).and_return(headers) }

      it 'sets the current user' do
        expect(subject.instance_eval { authorize_request }).to eq(user)
      end
    end

    context 'when no auth token is sent' do
      before { allow(request).to receive(:headers).and_return(invalid_headers) }

      it 'raises MissingToken error' do
        expect{ subject.instance_eval { authorize_request } }
          .to raise_error(ExceptionHandler::MissingToken, /Missing Token/)
      end
    end
  end
end