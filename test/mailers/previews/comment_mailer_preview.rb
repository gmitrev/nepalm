# Preview all emails at http://localhost:3000/rails/mailers/comment_mailer
class CommentMailerPreview < ActionMailer::Preview

  def notify_user
    @comment = Comment.last
    @user = User.first
    CommentMailer.notify_user(@user, @comment)
  end
end
