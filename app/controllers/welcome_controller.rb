class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to projects_path
    else
      render layout: 'landing'
    end
  end
end
