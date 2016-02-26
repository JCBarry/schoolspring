class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.date :date
      t.string :title
      t.string :employer
      t.string :location

      t.timestamps null: false
    end
  end
end
