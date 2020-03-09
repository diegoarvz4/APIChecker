class CreateAccessReports < ActiveRecord::Migration[5.2]
  def change
    create_table :access_reports do |t|
      t.datetime :entry
      t.datetime :exit

      t.timestamps
    end
  end
end
