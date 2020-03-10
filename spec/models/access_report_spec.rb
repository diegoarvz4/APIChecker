require 'rails_helper'

RSpec.describe AccessReport, type: :model do
  it { should validate_presence_of(:entry) }
  it { should belong_to(:employee) }
  it 'validates the uniqueness of an entry scoping an employee' do
    date = Time.now
    employee = User.create(name: 'Employee', username: 'BestEmployee', password: '123456', password_confirmation: '123456')
    employee.access_reports.create(entry: date)
    access_report = employee.access_reports.create(entry: date)
    expect(access_report).to_not be_valid
    expect(access_report.errors.messages[:entry]).to eq ['has already been taken']
  end
end