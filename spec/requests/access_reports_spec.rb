require 'rails_helper'

RSpec.describe 'Access Reports API', type: :request do
  # Access Reports Administrator
  let(:admin_user) { create(:user, admin: true) }
  let(:non_admin_1) { create(:user) }
  let(:non_admin_2) { create(:user) }

  let!(:access_reports_1) { create_list(:access_report, 3, employee_id: non_admin_1.id)}
  let!(:access_reports_2) { create_list(:access_report, 3, employee_id: non_admin_2.id)}

  let(:access_reports_id) { access_reports_1.first.id }
  let(:access_reports_id_2) { access_reports_2.first.id } 

  let(:admin_headers) {
    {
      'Content-Type' => 'application/json',
      'Authorization' => JsonWebToken.encode(user_id: admin_user.id)
    }
  }

  let(:non_admin_1_headers) {
    {
      'Content-Type' => 'application/json',
      'Authorization' => JsonWebToken.encode(user_id: non_admin_1.id)
    }
  }

  context 'When the user is an admin' do 
    describe 'GET /access_reports' do 
      before { get '/access_reports', params: {}, headers: admin_headers}

      it 'gives back all access reports' do
        expect(JSON.parse(response.body).size).to eq(6)
      end
    end

    describe 'GET /access_reports/:id' do
      before { get "/access_reports/#{1}", params: {}, headers: admin_headers}

      it 'gives back all access reports' do
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    describe 'POST /access_reports' do 
      let(:valid_attributes) {
        {
          employee_id: non_admin_1.id,
          entry: Time.now
        }
      }

      before { post "/access_reports", params: valid_attributes.to_json, headers: admin_headers }

      it 'creates the access report and gives back a success message' do
        expect(JSON.parse(response.body)['message']).to match(/Access Report created/)
      end
    end

    describe 'PUT /access_reports/:id' do
      let(:valid_attributes) {
        {
          entry: Time.now,
          exit: Time.now
        }
      }
      before { put "/access_reports/#{access_reports_id}", params: valid_attributes.to_json, headers: admin_headers }

      it "updates an access report with id" do
        expect(JSON.parse(response.body)['message']).to match(/Access Report updated!/)
      end
    end

    describe 'DELETE /access_reports/:id' do 

      before { delete "/access_reports/#{access_reports_id}", params: {}, headers: admin_headers }
      it "deletes an specific access report" do
        expect(JSON.parse(response.body)['message']).to match(/Access Report Deleted!/)
      end
    end

  end


  context 'when the user is not admin' do 
    describe 'GET /access_reports' do 
      before { get '/access_reports', params: {}, headers: non_admin_1_headers}

      it 'should give back their own access reports' do
        expect(JSON.parse(response.body).size).to eq(3)
      end
    end

    describe 'GET /access_reports/:id if it is the owner' do
      before { get "/access_reports/#{access_reports_id}", params: {}, headers: non_admin_1_headers}

      it 'gives its own access reports' do
        expect(JSON.parse(response.body)).to include("id" => access_reports_1.first.id)
      end
    end

    describe 'GET /access_reports/:id if it is not the owner' do
      before { get "/access_reports/#{access_reports_id_2}", params: {}, headers: non_admin_1_headers}

      it 'gives an error message' do
        expect(JSON.parse(response.body)['message']).to match(/Unauthorized/)
      end
    end

    describe 'POST /access_reports' do 
      let(:valid_attributes) {
        {
          employee_id: non_admin_1.id,
          entry: Time.now
        }
      }
      before { post "/access_reports", params: valid_attributes.to_json, headers: non_admin_1_headers }
      it 'gives an error message' do
        expect(JSON.parse(response.body)['message']).to match(/Unauthorized/)
      end
    end

    describe 'PUT /access_reports/:id' do
      let(:valid_attributes) {
        {
          entry: Time.now,
          exit: Time.now
        }
      }
      before { put "/access_reports/#{access_reports_id}", params: valid_attributes.to_json, headers: non_admin_1_headers }

      it "gives an error message" do
        expect(JSON.parse(response.body)['message']).to match(/Unauthorized/)
      end
    end

    describe 'DELETE /access_reports/:id' do 

      before { delete "/access_reports/#{access_reports_id}", params: {}, headers: non_admin_1_headers }
      it "gives an error message" do
        expect(JSON.parse(response.body)['message']).to match(/Unauthorized/)
      end
    end

  end

end