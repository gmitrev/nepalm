class MarkAllMessagesAsRead < ActiveRecord::Migration
  def change
    User.all.each do |user|
      Comment.mark_as_read! :all, for: user
    end
  end
end
