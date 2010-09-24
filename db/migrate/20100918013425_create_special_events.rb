class CreateSpecialEvents < ActiveRecord::Migration
  def self.up
    create_table :special_events do |t|
      t.string :title
      t.text :notes
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :all_day, :default => false
      t.references :instructor
      t.timestamps
    end
  end

  def self.down
    drop_table :special_events
  end
end
