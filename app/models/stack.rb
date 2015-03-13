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
#

class Stack < ActiveRecord::Base
  belongs_to :project
  has_many :task_lists

  has_many :memberships
  has_many :users, through: :memberships
  has_many :comments

  def summary
    if(read_attribute(:summary).present?)
      read_attribute(:summary)
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

  # Utility method
  def task_list
    task_lists.first
  end

  # Create default task list
  after_create do
    task_lists.create(name: "Tasks")
  end

end
