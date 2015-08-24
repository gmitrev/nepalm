# == Schema Information
#
# Table name: projects
#
#  id              :integer          not null, primary key
#  name            :string
#  owner_id        :integer
#  created_at      :datetime
#  updated_at      :datetime
#  total_file_size :integer          default("0")
#  archived        :boolean          default("false")
#

class Project < ActiveRecord::Base
  include Archivable

  has_many :stacks, -> { order('created_at DESC') }, dependent: :destroy

  belongs_to :owner, class_name: 'User'

  has_many :project_users
  has_many :users, through: :project_users

  after_create :create_default_stacks, :attach_owner

  scope :starred_by, -> (user) { joins(:project_users).where(project_users: {  user_id: user.id, starred: true }).limit(5) }
  scope :active, -> { where(archived: false) }

  def completed_tasks(user)
    completed = user_stacks(user).flat_map(&:completed_tasks_count).reduce(:+) || 0
    total = user_stacks(user).flat_map(&:total_tasks_count).reduce(:+) || 0

    "#{completed}/#{total}"
  end

  def completed_percentage(user)
    completed = user_stacks(user).flat_map(&:completed_tasks_count).reduce(:+) || 0
    total = user_stacks(user).flat_map(&:total_tasks_count).reduce(:+) || 0

    if total.zero? || completed.zero?
      0
    else
      (completed.to_f / total.to_f) * 100
    end
  end

  def comments_count(user)
    user_stacks(user).flat_map(&:comments).count
  end

  def unread_comments(user)
    user_stacks(user).flat_map(&:comments).select { |c| c.unread?(user) }
  end

  def unread_comments_count(user)
    unread_comments(user).count
  end

  def files_count(user)
    user_stacks(user).flat_map(&:files_count).reduce(:+) || 0
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

  def add_user(user)
    users << user unless users.include?(user)
  end

  def relation_with(user)
    project_users.find_by(user: user)
  end

  def starred_by?(user)
    relation_with(user).starred?
  end

  def star_for!(user)
    rel = relation_with(user)

    rel.update_column(:starred, !rel.starred?)
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

  def attach_owner
    add_user(owner)
  end

  def user_stacks(user)
    stacks.select { |s| s.users.include?(user) }
  end
end
