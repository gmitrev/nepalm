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
  has_many :stacks, -> { order("created_at ASC") }, through: :memberships
  has_many :comments

  has_many :projects, -> { order("created_at ASC") }, foreign_key: :owner_id

  has_many :subscriptions, class_name: 'CommentSubscription'
  has_many :subscribed_stacks, through: :subscriptions

  def all_projects
    (stacks.flat_map(&:project) + projects).flatten.uniq.sort_by(&:created_at)
  end

  def active_projects
    all_projects.reject(&:archived)
  end

  def archived_projects
    all_projects.select(&:archived)
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
