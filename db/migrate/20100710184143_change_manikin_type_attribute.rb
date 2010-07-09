class ChangeManikinTypeAttribute < ActiveRecord::Migration
  def self.up
    change_table :manikins do |t|
      t.rename :type, :sim_type
    end
  end

  def self.down
    change_table :manikins do |t|
      t.rename :sim_type, :type
    end
  end
end
