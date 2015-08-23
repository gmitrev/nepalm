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
#  name                   :string
#

class User < ActiveRecord::Base
  include GlobalID::Identification

  acts_as_reader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships
  has_many :stacks, -> { order('created_at ASC') }, through: :memberships
  has_many :comments

  has_many :owned_projects, -> { order('created_at ASC') }, foreign_key: :owner_id, class_name: 'Project'

  has_many :project_users
  has_many :projects, through: :project_users

  has_many :subscriptions, class_name: 'CommentSubscription'
  has_many :subscribed_stacks, through: :subscriptions

  def active_projects
    projects.where(archived: false)
  end

  def archived_projects
    projects.where(archived: true)
  end

  def human
    email
  end

  def membership(stack)
    Membership.find_by(user: self, stack: stack)
  end

  def subscribed_to?(stack)
    subscription = subscriptions.where(stack: stack).first
    subscription.subscribed?
  rescue StandardError
    false
  end

  def to_s
    name || email
  end
end
