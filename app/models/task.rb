# == Schema Information
#
# Table name: tasks
#
#  id           :integer          not null, primary key
#  name         :string
#  task_list_id :integer
#  completed    :boolean
#  created_at   :datetime
#  updated_at   :datetime
#  completed_at :datetime
#

class Task < ActiveRecord::Base
  belongs_to :task_list

  has_many :work_logs

  def not_completed?
    !completed?
  end

  def complete!
    update_attributes(completed: true, completed_at: Time.now)
  end

  def uncomplete!
    update_column(:completed, false)
  end

  def toggle!
    update_column(:completed, !self.completed?)

    if self.completed?
      update_column(:completed_at, Time.now)
    else
      update_column(:completed_at, nil)
    end
  end

  def total_time_logged
    work_logs.map { |log| log.time.to_i }.sum
  end
end
