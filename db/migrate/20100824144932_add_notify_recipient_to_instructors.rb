class AddNotifyRecipientToInstructors < ActiveRecord::Migration
  def self.up
    change_table :instructors do |t|
      t.boolean :notify_recipient, :default => false
    end
  end

  def self.down
    change_table :instructors do |t|
      t.remove :notify_recipient
    end
  end
end
