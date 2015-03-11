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

class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :stack

  # before_save :check_at_least_one_admin

  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end

  # def check_at_least_one_admin
  #   other = organization.memberships - [self]
  #   any_admins = other.any?(&:admin?)
  #
  #   if user? && role_was == 'admin' && !any_admins
  #     self.errors.add(:base, "All organizations should have at least one admin")
  #     false
  #   end
  # end


end
