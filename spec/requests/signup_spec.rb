require 'rails_helper'

RSpec.describe 'Signup API', type: :request do 
  let(:user) { build(:user) }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  let(:valid_attributes){
    {
      user: {
        name: user.name,
        username: user.username,
        password: user.password,
        password_confirmation: user.password
      }
    }
  }

  let(:invalid_attributes){
    {
      user: {
        name: '',
        username: '',
        password: '',
        password_confirmation: ''
      }
    }
  }

  describe 'POST /signup' do 

    # if credentials are correct, signup the user
    context 'when the request is valid' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'creates a new employee' do
        expect(response).to have_http_status(201)
      end

      it 'returns a success message' do 
        expect(JSON.parse(response.body)['message']).to match(/Account Created/)
      end

      it 'returns an authentication token' do
        expect(JSON.parse(response.body)['auth_token']).not_to be_nil
      end
    end

    # if credentials are missing raise and error
    context 'when the request is invalid' do
      before { post '/signup', params: invalid_attributes.to_json, headers: headers }

      it 'does not creates a new employee' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)['message']).to match(/Validation failed: Password can't be blank, Name can't be blank, Username can't be blank/)
      end
    end
  end

end