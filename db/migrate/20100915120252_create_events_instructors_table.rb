class CreateEventsInstructorsTable < ActiveRecord::Migration
  def self.up
    create_table :events_instructors, :id => false do |t|
      t.integer :event_id
      t.integer :instructor_id
    end
  end

  def self.down
    drop_table :events_instructors
  end
end
