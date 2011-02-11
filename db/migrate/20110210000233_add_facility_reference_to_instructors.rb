class AddFacilityReferenceToInstructors < ActiveRecord::Migration
  def self.up
    change_table :instructors do |t|
      t.belongs_to :facility
    end
  end

  def self.down
    change_table :instructors do |t|
      t.remove_belongs_to :facility
    end
  end
end
