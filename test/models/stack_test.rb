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

require 'test_helper'

class StackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
