class AddFacilityReferenceToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.belongs_to:facility
    end
  end

  def self.down
    change_table :events do |t|
      t.remove_belongs_to :facility
    end
  end
end
