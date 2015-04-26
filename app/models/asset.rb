class Asset < ActiveRecord::Base
  belongs_to :user

  has_attached_file :file,
    styles: ->(a) { a.instance.styles },
    # default_url: 'missing.png',
    storage: :s3,
    s3_credentials: Proc.new{ |a| a.instance.s3_credentials }

  has_many :attachments
  has_many :attached_to, through: :attachments
  # validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :file, content_type: %w(image/jpeg image/jpg image/png image/gif application/pdf application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document text/plain application/x-download)
  # do_not_validate_attachment_file_type :file

  def s3_credentials
    {
      bucket: ENV['S3_BUCKET'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
  end

  def image?
    file.content_type.index("image/") == 0
  end

  def styles
    if image?
      { :medium => "300x300>", :thumb => "100x100>" }
    else
      {}
    end
  end
end
