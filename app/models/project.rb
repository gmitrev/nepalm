# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  owner_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
  has_many :stacks

  belongs_to :owner, class_name: "User"
end
