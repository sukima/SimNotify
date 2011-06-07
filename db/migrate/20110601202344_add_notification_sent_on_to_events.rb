class AddNotificationSentOnToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.datetime :notification_sent_on
    end
  end

  def self.down
    change_table :events do |t|
      t.remove :notification_sent_on
    end
  end
end
