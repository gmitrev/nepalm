class TaskList < ActiveRecord::Base
  belongs_to :stack
  has_many :tasks
end
