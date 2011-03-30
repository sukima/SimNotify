class AddTitleToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :title, :text, :null => false
  end

  def self.down
    remove_column :scenarios, :title
  end
end
