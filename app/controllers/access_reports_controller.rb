class AccessReportsController < ApplicationController
  before_action :allowed?

  def index
    access_reports = 
      if current_user.admin?
        AccessReport.all
      else
        current_user.access_reports
      end
    render json: access_reports, 
      except: [:created_at, :updated_at],
      status: :ok
  end

  def create
    access_report = AccessReport.create!(access_reports_params)
    render json: { message: 'Access Report created'}, status: :created
  end

  def update
    access_report = AccessReport.find(params[:id])
    access_report.update_attributes(access_reports_params)
    access_report.save!
    render json: { message: 'Access Report updated!'}, status: :accepted
  end

  def destroy
    access_report = AccessReport.find(params[:id])
    access_report.destroy
    render json: { message: 'Access Report Deleted!'}, status: :ok
  end

  private

  def access_reports_params
    params.require(:access_report).permit(:entry, :exit, :employee_id)
  end

  def allowed?
    render json: { message: 'Unauthorized'}, status: :unauthorized unless current_user.admin
  end
end
