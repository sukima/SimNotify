class CreateScenarioTemplates < ActiveRecord::Migration
  def self.up
    create_table :scenario_templates do |t|
      t.string :title, :null => false
      t.text :equipment
      t.boolean :staff_support
      t.boolean :moulage
      t.text :notes
      t.text :support_material
      t.text :description
      t.boolean :video
      t.boolean :mobile
      t.timestamps
    end
  end

  def self.down
    drop_table :scenario_templates
  end
end
