class WorkLog < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  validates :task, :user, presence: true

  before_save :parse_time

  private

  def parse_time
    self.time = ChronicDuration.parse(time)
  end
end
