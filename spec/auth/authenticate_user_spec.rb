require 'rails_helper'

RSpec.describe AuthenticateUser do
  # create the user factory object
  let(:user) { create(:user) }
  # valid user for getting a token
  subject(:valid_auth) { described_class.new(user.username, user.password) }
  # invalid user for raising an error
  subject(:invalid_auth) { described_class.new('some_user', 'some_password') }

  describe '#AuthenticateUser call' do
    # if valid request, return a valid token
    context 'when valid credentials' do
      it 'gives back an auth token' do
        auth_token = valid_auth.call
        expect(auth_token).not_to be_nil
      end
    end
    # if invalid user credentials then raise an error
    context 'when invalid credentials' do
      it 'gives back an error message' do
        expect { invalid_auth.call }.to raise_error(ExceptionHandler::AuthenticationError, /Invalid credentials/) 
      end
    end
  end

end