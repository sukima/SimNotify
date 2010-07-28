class AddEventsSubmittedFlag < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.boolean :submitted, :default => false
      t.boolean :approved, :default => false
    end
  end

  def self.down
    change_table :events do |t|
      t.remove :submitted
      t.remove :approved
    end
  end
end
