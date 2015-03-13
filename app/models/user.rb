# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ActiveRecord::Base
  include GlobalID::Identification

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships
  has_many :stacks, through: :memberships
  has_many :comments

  has_many :projects, foreign_key: :owner_id

  def all_projects
    (stacks.flat_map(&:project) + projects).flatten.uniq
    # owners = [self, self.organizations.all].flatten.map do |o|
    #   "(projects.owner_id = #{o.id} AND projects.owner_type = '#{o.class.name}')"
    # end.join(" OR ")
    #
    # projects
    #
    # Project.where(owners)
  end

  def human
    email
  end

  def membership(stack)
    Membership.find_by(user: self, stack: stack)
  end
end
