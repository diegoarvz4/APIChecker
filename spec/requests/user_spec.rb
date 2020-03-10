require 'rails_helper'

RSpec.describe 'Employees API', type: :request do 
  let(:user_admin) { create(:user, admin: true) }
  let(:not_admin) { create(:user) }

  let(:admin_headers) {
    {
      'Content-Type' => 'application/json',
      'Authorization' => JsonWebToken.encode(user_id: user_admin.id)
    }
  }

  let(:non_admin_headers) {
    {
      'Content-Type' => 'application/json',
      'Authorization' => JsonWebToken.encode(user_id: not_admin.id)
    }
  }

  describe 'GET /employees' do

    # if admin user fetch all employes
    context 'when admin get employees' do
      before { get '/employees', params: {}, headers: admin_headers }

      it 'fetches all non-admin users, employees' do
        expect(response).to have_http_status(200)
      end
    end

    # if not-admin then unauthorize the petition
    context 'when a non-admin user request' do
      before { get '/employees', params: {}, headers: non_admin_headers }

      it 'raises an error and returns a failure message' do
        expect(JSON.parse(response.body)['message']).to match(/Unauthorized/)
      end
    end
  end

  describe 'GET /employees/:id' do

    # if admin then fetch spefici employee
    context 'when admin gets specific employee' do
      before { get "/employees/#{not_admin.id}", params: {}, headers: admin_headers }

      it 'fetches a specific employee' do
        expect(response).to have_http_status(200)
      end

    end

    # if not-admin, in can only fetch its own user
    context 'when user that is not admin tries to fetch users' do 
      before { get "/employees/#{user_admin.id}", params: {}, headers: non_admin_headers}

      it 'returns a failure unauthorized message' do
        expect(JSON.parse(response.body)['message']).to match(/Unauthorized/)
      end
    end

    context 'when use tries to fetch its own user object' do 
      before { get "/employees/#{not_admin.id}", params: {}, headers: non_admin_headers}

      it 'returns a failure unauthorized message' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PUT /employees/:id' do
    let(:valid_attributes) {
      {
        name: 'Jose',
        username: '@Jose_Company'
      }
    }

    # only admin can edit an employees info
    context 'when admin tries to edit an employee info' do
      before { put "/employees/#{not_admin.id}", params: valid_attributes.to_json, headers: admin_headers }

      it 'updates an specific employee' do
        expect(response).to have_http_status(200)
      end
    end

    # if not admin, raise unauthorized error message
    context 'when non-admin tries to edit an employee info' do
      before { put "/employees/#{not_admin.id}", params: valid_attributes.to_json, headers: non_admin_headers }

      it 'returns an unathorized message' do
        expect(JSON.parse(response.body)['message']).to match(/Unauthorized/)
      end
    end
  end
end
