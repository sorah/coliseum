class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= session[:user_id] ? User.find(session[:user_id]) : nil
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
    @current_user = nil
  end
  helper_method :current_user

  private

  def check_logged_in
    unless current_user
      return render nothing: true, status: :unauthorized
    end
  end
end
