class CreateManikinReqTypes < ActiveRecord::Migration
  def self.up
    create_table :manikin_req_types do |t|
      t.string :req_type, :null => false
    end
    change_table :manikins do |t|
      t.references :manikin_req_type
    end
    change_table :scenarios do |t|
      t.references :manikin_req_type
    end
  end

  def self.down
    change_table :manikins do |t|
      t.remove_references :manikin_req_type
    end
    change_table :scenarios do |t|
      t.remove_references :manikin_req_type
    end
    drop_table :manikin_req_types
  end
end
