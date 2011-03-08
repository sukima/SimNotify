class CreateAssetsEventsTable < ActiveRecord::Migration
  def self.up
    create_table :assets_events, :id => false do |t|
      t.references :asset
      t.references :event
    end
  end

  def self.down
    drop_table :assets_events
  end
end
