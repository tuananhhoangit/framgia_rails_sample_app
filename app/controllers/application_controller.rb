class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def valid_info object
    render file: "public/404.html", layout: false unless object
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t ".pls_login"
      redirect_to login_url
    end
  end
end
