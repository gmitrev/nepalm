class Project < ActiveRecord::Base
  has_many :stacks

  belongs_to :owner, class_name: "User"
end
