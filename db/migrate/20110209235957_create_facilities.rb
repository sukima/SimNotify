class CreateFacilities < ActiveRecord::Migration
  def self.up
    create_table :facilities do |t|
      t.string :name, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :facilities
  end
end
