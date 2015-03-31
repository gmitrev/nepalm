class CommentMailer < ApplicationMailer
  default from: 'no-reply@nepalm.com'

  def notify_user(user, comment)
    @comment = comment
    mail(to: user.email, from: "#{comment.user.email} <no-reply@nepalm.com>", subject: "#{comment.stack.project.name}/#{comment.stack.name} - Discussion")
  end
end
