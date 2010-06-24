class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :location, :null => false
      t.text :benefit, :null => false
      t.text :notes
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :live_in, :default => false
      t.reference :instructor
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
