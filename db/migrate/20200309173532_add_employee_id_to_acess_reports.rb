class AddEmployeeIdToAcessReports < ActiveRecord::Migration[5.2]
  def change
    add_reference :access_reports, :employee, foreign_key: { to_table: :users}
  end
end
