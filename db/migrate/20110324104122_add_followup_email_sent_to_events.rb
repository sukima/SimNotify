class AddFollowupEmailSentToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :followup_email_sent, :boolean, :default => false
  end

  def self.down
    remove_column :events, :followup_email_sent
  end
end
