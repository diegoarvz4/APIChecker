class AccessReportsController < ApplicationController

  def index
    access_reports = 
      if current_user.admin?
        AccessReport.all
      else
        current_user.access_reports
      end
    render json: access_reports, status: :ok
  end

  private

  def access_reports_params
    params.require(:access_report).permit(:entry, :exit, :employee_id)
  end
end
