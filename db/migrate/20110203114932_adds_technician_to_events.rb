class AddsTechnicianToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.belongs_to :technician
    end
  end

  def self.down
    change_table :events do |t|
      t.remove_belongs_to :technician
    end
  end
end
