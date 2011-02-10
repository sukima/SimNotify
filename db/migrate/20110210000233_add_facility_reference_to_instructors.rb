class AddFacilityReferenceToInstructors < ActiveRecord::Migration
  def self.up
    change_table :instructors do |t|
      t.reference :facility
    end
  end

  def self.down
    change_table :instructors do |t|
      t.remove_reference :facility
    end
  end
end
