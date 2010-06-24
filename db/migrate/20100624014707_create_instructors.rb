class CreateInstructors < ActiveRecord::Migration
  def self.up
    create_table :instructors do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :office
      t.string :phone
      t.boolean :admin, :default => false
      t.string :persistence_token
#      t.string :crypted_password
#      t.string :password_salt
      t.timestamps
    end
  end
  
  def self.down
    drop_table :instructors
  end
end
