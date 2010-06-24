class CreateScenarios < ActiveRecord::Migration
  def self.up
    create_table :scenarios do |t|
      t.text :equipment
      t.boolean :staff_support
      t.boolean :moulage
      t.text :notes
      t.text :support_material
      t.text :description
      t.boolean :video
      t.boolean :mobile
      t.references :event
    end
  end

  def self.down
    drop_table :scenarios
  end
end
