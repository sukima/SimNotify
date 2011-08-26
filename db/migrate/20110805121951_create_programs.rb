class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.string :name
      t.text :description
      t.text :benifit
      t.references :contact
      t.references :created_by
      t.timestamps
    end
  end

  def self.down
    drop_table :programs
  end
end
