class CreateEquipmentSuggestions < ActiveRecord::Migration
  def self.up
    create_table :equipment_suggestions do |t|
      t.string :title
      t.text :description
    end
  end

  def self.down
    drop_table :equipment_suggestions
  end
end
