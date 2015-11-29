class CreateWorkLogs < ActiveRecord::Migration
  def change
    create_table :work_logs do |t|
      t.string :time
      t.text :comment
      t.references :task, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :work_logs, :tasks
    add_foreign_key :work_logs, :users
  end
end
