# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  stack_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role       :string           default("user")
#

require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
