# == Schema Information
#
# Table name: task_lists
#
#  id         :integer          not null, primary key
#  name       :string
#  stack_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class TaskList < ActiveRecord::Base
  belongs_to :stack
  has_many :tasks, dependent: :destroy
end
