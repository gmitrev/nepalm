class Comment < ActiveRecord::Base
  acts_as_readable :on => :created_at

  belongs_to :user
  belongs_to :stack

  alias :author :user

  after_save :set_read_by_author

  def notify_all!
    parties = self.stack.users.uniq - [author]

    parties.each do |party|
      CommentMailer.notify_user(party, self).deliver
    end
  end

  private

  def set_read_by_author
    self.mark_as_read! for: author
  end

end
