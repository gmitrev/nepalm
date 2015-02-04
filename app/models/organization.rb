class Organization < ActiveRecord::Base
  include GlobalID::Identification

  has_many :memberships
  has_many :users, through: :memberships

  has_many :projects, as: :owner

  validates :name, uniqueness: true

  def human
    name
  end
end
