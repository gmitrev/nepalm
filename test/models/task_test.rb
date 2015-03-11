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
#

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
