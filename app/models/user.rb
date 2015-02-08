class User < ActiveRecord::Base
  include GlobalID::Identification

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships
  has_many :organizations, through: :memberships

  has_many :projects, as: :owner

  def all_projects
    owners = [self, self.organizations.all].flatten.map do |o|
      "(projects.owner_id = #{o.id} AND projects.owner_type = '#{o.class.name}')"
    end.join(" OR ")

    Project.where(owners)
  end

  def human
    email
  end

  def membership(organization)
    Membership.find_by(user: self, organization: organization)
  end
end
