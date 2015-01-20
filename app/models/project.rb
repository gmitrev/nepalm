class Project < ActiveRecord::Base
  has_many :stacks
  belongs_to :user
end
