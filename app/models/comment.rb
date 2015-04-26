class Comment < ActiveRecord::Base
  acts_as_readable on: :created_at

  belongs_to :user
  belongs_to :stack

  has_many :attachments, as: :parent, dependent: :destroy
  has_many :attached_files, through: :attachments, source: :asset

  alias_method :author, :user

  after_save :set_read_by_author

  validates :body, presence: true

  def notify_all!
    parties = (stack.users.uniq - [author]).flatten.select { |u| u.subscribed_to?(stack) }

    parties.each do |party|
      CommentMailer.notify_user(party, self).deliver
    end
  end

  def add_files(files)
    files.each do |file|
      attached_files.create(file: file)
    end
  end

  private

  def set_read_by_author
    self.mark_as_read! for: author
  end
end
