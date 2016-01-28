class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :time_travel

  def time_travel
    if !params[:time_travel].nil?
      Timecop.travel(Time.at(params[:time_travel].to_i))
    else
      Timecop.return
    end
  end

  def after_sign_in_path_for(resource)
    if resource.role?('admin')
      admin_dashboard_path
    else
      edit_user_path
    end
  end

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.role?(:admin)
      flash[:danger] = "Not authorized to access to this resouce!"
      redirect_to root_path
    end
  end
end
