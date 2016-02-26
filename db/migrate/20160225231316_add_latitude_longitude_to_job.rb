class AddLatitudeLongitudeToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :latitude, :string
    add_column :jobs, :longitude, :string
  end
end
