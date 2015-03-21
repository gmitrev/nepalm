# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  owner_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
  has_many :stacks, dependent: :destroy

  belongs_to :owner, class_name: "User"

  def users
    stacks.flat_map(&:users)
  end

  def completed_tasks(user)
    user_stacks = stacks.select { |s| s.users.include?(user) }

    completed = user_stacks.flat_map(&:completed_tasks_count).reduce(:+) || 0
    total = user_stacks.flat_map(&:total_tasks_count).reduce(:+) || 0

    "#{completed}/#{total}"
  end

  def completed_percentage(user)
    user_stacks = stacks.select { |s| s.users.include?(user) }

    completed = user_stacks.flat_map(&:completed_tasks_count).reduce(:+) || 0
    total = user_stacks.flat_map(&:total_tasks_count).reduce(:+) || 0

    if total.zero? || completed.zero?
      0
    else
      (completed.to_f / total.to_f) * 100
    end
  end

  def comments_count(user)
    user_stacks = stacks.select { |s| s.users.include?(user) }
    user_stacks.flat_map(&:comments).count
  end

  def unread_comments(user)
    user_stacks = stacks.select { |s| s.users.include?(user) }
    user_stacks.flat_map(&:comments).select { |c| c.unread?(user) }
  end

  def unread_comments_count(user)
    unread_comments(user).count
  end

  def to_s
    name
  end
end
