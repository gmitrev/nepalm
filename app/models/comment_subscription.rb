class CommentSubscription < ActiveRecord::Base
  belongs_to :stack
  belongs_to :user

  def subscribe!
    update_column(:subscribed, true)
  end

  def unsubscribe!
    update_column(:subscribed, false)
  end
end
