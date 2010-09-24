class CreateLocationSuggestions < ActiveRecord::Migration
  def self.up
    create_table :location_suggestions do |t|
      t.string :location, :null => false
    end
  end

  def self.down
    drop_table :location_suggestions
  end
end
