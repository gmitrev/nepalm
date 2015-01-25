class Stack < ActiveRecord::Base
  belongs_to :project
  has_many :task_lists

  def summary
    if(read_attribute(:summary).present?)
      read_attribute(:summary)
    else
      'No summary available'
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
