class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def admin_for?(organization)
    current_user.membership(organization).admin?
  end

  def authorize_user!(organization)
    if !admin_for?(organization)
      redirect_to :root, notice: "Not authorized"
    end
  end

  helper_method :admin_for?

end


