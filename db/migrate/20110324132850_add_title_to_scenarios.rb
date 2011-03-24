class AddTitleToScenarios < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :title, :boolean, :null => false
  end

  def self.down
    remove_column :scenarios, :title
  end
end
