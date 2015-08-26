# == Schema Information
#
# Table name: stacks
#
#  id         :integer          not null, primary key
#  name       :string
#  summary    :text
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#  archived   :boolean          default("false")
#

class Stack < ActiveRecord::Base
  include Archivable

  belongs_to :project
  has_many :task_lists, dependent: :destroy

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :comments, dependent: :destroy

  has_many :subscriptions, class_name: 'CommentSubscription', dependent: :destroy
  has_many :subscribers, through: :subscriptions

  def summary
    if self[:summary].present?
      self[:summary]
    else
      'No summary available'
    end
  end

  def completed_tasks_count
    task_list.tasks.select(&:completed?).count
  end

  def total_tasks_count
    task_list.tasks.count
  end

  def completed_tasks
    "#{completed_tasks_count}/#{total_tasks_count}"
  end

  def completed_percentage
    if total_tasks_count.zero? || completed_tasks_count.zero?
      0
    else
      (completed_tasks_count.to_f / total_tasks_count.to_f) * 100
    end
  end

  def unread_comments(user)
    comments.select { |c| c.unread?(user) }
  end

  def unread_comments_count(user)
    unread_comments(user).count
  end

  def latest_comments(user)
    coll = comments.order('created_at desc').limit(10)
    unread = coll.select { |c| c.unread?(user) }
    # mark all as read
    unread.each { |c| c.mark_as_read!(for: user) }
    [coll, unread.map(&:id)]
  end

  # Utility method
  def task_list
    task_lists.first
  end

  # Create default task list
  after_create do
    task_lists.create(name: 'Tasks')

    users.each { |user| subscribe!(user) }
  end

  def to_s
    name
  end

  def subscribe!(user)
    CommentSubscription.find_or_create_by(user: user, stack: self).subscribe!
  end

  def files_count
    comments.includes(:attached_files).flat_map(&:attached_files).count
  end

  # Add a new user to the stack. Mark all comments as read, subscribe the
  # user to the discussion and add them to the project's user pool
  def add_user(user)
    comments.each { |c| c.mark_as_read!(for: user) }
    subscribe!(user)
    project.add_user(user)
  end

  class << self
    def setup(params, project_id, user)
      stack = new(params.merge(project_id: project_id))
      stack.users << user
      stack.memberships.detect { |m| m.user == user }.role = 'admin' # First user should be admin
      stack
    end

  end

end
