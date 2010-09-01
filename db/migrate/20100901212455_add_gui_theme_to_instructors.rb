class AddGuiThemeToInstructors < ActiveRecord::Migration
  def self.up
    change_table :instructors do |t|
      t.string :gui_theme
    end
  end

  def self.down
    change_table :instructors do |t|
      t.remove :gui_theme
    end
  end
end
