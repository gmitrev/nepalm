class CreateTaskLists < ActiveRecord::Migration
  def change
    create_table :task_lists do |t|
      t.string :name
      t.integer :stack_id

      t.timestamps
    end
  end
end
