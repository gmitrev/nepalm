class CreateStacks < ActiveRecord::Migration
  def change
    create_table :stacks do |t|
      t.string :name
      t.text :summary
      t.integer :project_id

      t.timestamps
    end
  end
end
