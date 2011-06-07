# followup_email_sent is now deprecated. Use notification_sent_on instead.
class RemoveFollowupEmailSentFromEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :followup_email_sent
  end

  def self.down
    add_column :events, :followup_email_sent, :boolean, :default => false
  end
end
