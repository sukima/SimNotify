class CreateManikins < ActiveRecord::Migration
  def self.up
    create_table :manikins do |t|
      t.string :name
      t.string :serial_number
      t.string :type
      t.boolean :oos
    end
    change_table :scenarios do |t|
      t.references :manikin
    end
    change_table :scenario_templates do |t|
      t.references :manikin
    end
  end

  def self.down
    change_table :scenarios do |t|
      t.remove_references :manikin
    end
    change_table :scenario_templates do |t|
      t.remove_references :manikin
    end
    drop_table :manikins
  end
end
