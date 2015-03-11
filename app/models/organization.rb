# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Organization < ActiveRecord::Base
  include GlobalID::Identification

  has_many :memberships
  has_many :users, through: :memberships

  has_many :projects, as: :owner

  validates :name, uniqueness: true

  def human
    name
  end

  before_create do
    memberships.first.role = 'admin'
  end

end
