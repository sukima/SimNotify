class AddInstructorToAssets < ActiveRecord::Migration
  def self.up
    change_table :assets do |t|
      t.belongs_to :instructor
    end
  end

  def self.down
    t.remove_belongs_to :instructor
  end
end
