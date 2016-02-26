class AddJobId < ActiveRecord::Migration
  def change
    add_column :jobs, :job_id, :integer
    add_index :jobs, :job_id, :unique => true
  end
end
