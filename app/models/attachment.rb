# == Schema Information
#
# Table name: attachments
#
#  id          :integer          not null, primary key
#  asset_id    :integer
#  parent_id   :integer
#  parent_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Attachment < ActiveRecord::Base
  belongs_to :asset
  belongs_to :parent, polymorphic: true
end
