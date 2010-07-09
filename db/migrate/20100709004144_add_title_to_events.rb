class AddTitleToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.string :title
    end
  end

  def self.down
    change_table :events do |t|
      t.remove :title
    end
  end
end
