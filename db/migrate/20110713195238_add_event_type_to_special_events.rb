class AddEventTypeToSpecialEvents < ActiveRecord::Migration
  def self.up
    change_table :special_events do |t|
      t.string :event_type
    end
  end

  def self.down
    change_table :special_events do |t|
      t.remove :event_type
    end
  end
end
