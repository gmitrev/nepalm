require 'active_support/concern'

module Archivable
  extend ActiveSupport::Concern

  included do
    scope :active,   -> { where(archived: false) }
    scope :archived, -> { where(archived: true) }
  end

  def archive!
    update_column(:archived, true)
  end

  def active?
    !archived?
  end

end
