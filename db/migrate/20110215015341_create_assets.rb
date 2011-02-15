class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :session_asset_file_name
      t.string :session_asset_content_type
      t.integer :session_asset_file_size
      t.datetime :session_asset_updated_at
      # t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
