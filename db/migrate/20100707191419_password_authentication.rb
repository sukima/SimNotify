class PasswordAuthentication < ActiveRecord::Migration
  def self.up
    change_table :instructors do |t|
      t.string :crypted_password
      t.string :password_salt
    end
  end

  def self.down
    change_table :instructors do |t|
      t.remove :crypted_password
      t.remove :password_salt
    end
  end
end
