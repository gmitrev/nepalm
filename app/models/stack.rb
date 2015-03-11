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

  def summary
    if(read_attribute(:summary).present?)
      read_attribute(:summary)
    else
      'No summary available'
    end
  end

  def completed_tasks
    tasks = task_list.tasks
    total = tasks.count
    completed = tasks.select(&:completed?).count

    "#{completed}/#{total}"
  end

  def completed_percentage
    tasks = task_list.tasks
    total = tasks.count
    completed = tasks.select(&:completed?).count

    if total.zero? || completed.zero?
      0
    else
      (completed.to_f / total.to_f) * 100
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
