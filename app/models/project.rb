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
  include Archivable

  has_many :stacks, -> { order('created_at DESC') }, dependent: :destroy

  belongs_to :owner, class_name: 'User'

  after_create :create_default_stacks

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

  def total_file_size_mb
    if total_file_size.to_f > 0
      total_file_size.to_f / 1.megabyte
    else
      0
    end
  end

  def disk_usage_limit
    100.megabytes
  end

  def disk_usage_percentage
    total_file_size.to_f / disk_usage_limit.to_f * 100
  end

  def free_disk_space
    disk_usage_limit - total_file_size
  end

  def enough_disk_space_for?(required_disk_space)
    free_disk_space > required_disk_space
  end

  private

  def create_default_stacks
    stack_params = {
      name: 'Todo',
      summary: 'Default todo stack',
      project: self
    }

    stack = Stack.new(stack_params)
    stack.users << owner
    stack.memberships.detect { |s| s.user == owner }.role = 'admin'
    stack.save
  end
end
