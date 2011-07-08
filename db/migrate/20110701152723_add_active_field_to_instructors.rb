class AddActiveFieldToInstructors < ActiveRecord::Migration
  def self.up
    change_table :instructors do |t|
      t.boolean :active, :default => true
    end
  end

  def self.down
    change_table :instructors do |t|
      t.remove :active
    end
  end
end
