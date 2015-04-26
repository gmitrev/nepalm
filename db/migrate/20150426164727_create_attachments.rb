class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :asset, index: true
      t.integer :parent_id
      t.string :parent_type

      t.timestamps null: false
    end
    add_foreign_key :attachments, :assets
  end
end
