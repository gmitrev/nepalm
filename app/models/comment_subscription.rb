# == Schema Information
#
# Table name: comment_subscriptions
#
#  id         :integer          not null, primary key
#  stack_id   :integer
#  user_id    :integer
#  subscribed :boolean          default("true")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
