class CreateProgramSubmissions < ActiveRecord::Migration
  def self.up
    create_table :program_submissions do |t|
      t.string  :name
      t.string  :job_title
      t.string  :department
      t.string  :phone
      t.string  :email
      t.text    :summery
      t.text    :outcome
      t.boolean :supervisor_notified
      t.string  :proximity
      t.text    :additional_info
      t.timestamps
    end
  end

  def self.down
    drop_table :program_submissions
  end
end
