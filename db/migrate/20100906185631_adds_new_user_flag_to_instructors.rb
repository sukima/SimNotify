class AddsNewUserFlagToInstructors < ActiveRecord::Migration
  def self.up
    change_table :instructors do |t|
      t.boolean :new_user, :default => true
    end
  end

  def self.down
    change_table :instructors do |t|
      t.remove :new_user
    end
  end
end
