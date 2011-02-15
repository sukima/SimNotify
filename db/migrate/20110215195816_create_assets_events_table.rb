class CreateAssetsEventsTable < ActiveRecord::Migration
  def self.up
    create_table :assets_events, :id => false do |t|
      t.integer :event_id
      t.integer :asset_id
    end
  end

  def self.down
    drop_table :assets_events
  end
end
