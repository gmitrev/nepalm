class CreateCommentSubscriptions < ActiveRecord::Migration
  def change
    create_table :comment_subscriptions do |t|
      t.references :stack, index: true
      t.references :user, index: true
      t.boolean :subscribed, default: true

      t.timestamps null: false
    end
    add_foreign_key :comment_subscriptions, :stacks
    add_foreign_key :comment_subscriptions, :users
  end
end
