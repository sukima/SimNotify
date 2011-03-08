class AddIsTechToInstructors < ActiveRecord::Migration
  def self.up
    change_table :instructors do |t|
      t.boolean :is_tech, :default => false
    end
  end

  def self.down
    change_table :instructors do |t|
      t.remove :is_tech
    end
  end
end
