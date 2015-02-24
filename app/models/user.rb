class User < ActiveRecord::Base
  include GlobalID::Identification

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships
  has_many :stacks, through: :memberships

  has_many :projects, foreign_key: :owner_id

  def all_projects
    stacks.flat_map(&:project).uniq
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
