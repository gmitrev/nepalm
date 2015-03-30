class SubscribeAllToAll < ActiveRecord::Migration
  def change
    Stack.all.each do |stack|
      stack.users.each { |user| stack.subscribe!(user) }
    end
  end
end
