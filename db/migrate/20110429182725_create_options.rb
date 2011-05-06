class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.string :name, :null => false
      t.string :value
    end
  end

  def self.down
    drop_table :options
  end
end
