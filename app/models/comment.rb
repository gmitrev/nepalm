# == Schema Information

# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  user_id    :integer
#  stack_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  acts_as_readable on: :created_at

  belongs_to :user
  belongs_to :stack

  has_many :attachments, as: :parent, dependent: :destroy
  has_many :attached_files, through: :attachments, source: :asset

  after_save :set_read_by_author

  validates :body, presence: true

  delegate :project, to: :stack
  alias_method :author, :user



  def notify_all!
    parties = (stack.users.uniq - [author]).flatten.select { |u| u.subscribed_to?(stack) }

    parties.each do |party|
      CommentMailer.notify_user(party, self).deliver
    end
  end

  def add_files(files)
    required_disk_space = files.flat_map(&:tempfile).map(&:size).reduce(:+)

    if enough_disk_space_for?(required_disk_space)
      additional_space = files.map do |file|
        if false
          file = attached_files.create(file: file)

          file.persisted? ? file.file_file_size : 0
        else
        end
      end.compact.reduce(:+) || 0

      project.update_column(:total_file_size, project.total_file_size + additional_space)
    else
      errors[:base] << "You have reached your disk space limit. Upgrade project for more space and other goodies."
      false
    end
  end

  def project
    stack.project
  end

  private

  def set_read_by_author
    self.mark_as_read!(for: author)
  end

  def enough_disk_space_for?(required_disk_space)
    project.free_disk_space > required_disk_space
  end
end
