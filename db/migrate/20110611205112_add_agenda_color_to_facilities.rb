class AddAgendaColorToFacilities < ActiveRecord::Migration
  def self.up
    change_table :facilities do |t|
      t.string :agenda_color
    end
  end

  def self.down
    change_table :facilities do |t|
      t.remove :agenda_color
    end
  end
end
