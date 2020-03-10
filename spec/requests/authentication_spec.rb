require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /login' do
    let!(:user) { create(:user) }

    let(:headers) { { 'Content-Type' => 'application/json' } }

    let(:valid_user) do
      { username: user.username, password: user.password }.to_json
    end

    let(:invalid_user) do
      { username: 'some_user', password: 'some_password'}.to_json
    end

    context 'when request is valid' do
      before { post '/login', params: valid_user, headers: headers }

      it 'gives back an authentication token' do
        expect(JSON.parse(response.body)['auth_token']).not_to be_nil
      end
    end

    context 'when request is not valid' do
      before { post '/login', params: invalid_user, headers: headers }

      it 'raises an error and returns a failure message' do
        expect(JSON.parse(response.body)['message'])
          .to match(/Invalid credentials/)
      end
    end
  end
end
