class ApplicationController < ActionController::Base
  protect_from_forgery
  config.filter_parameters :password, :password_confirmation
  helper_method :current_user_session, :current_user

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end



  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end


  def require_admin_user
    if current_user && current_user.admin?
      return true
    elsif current_user && !current_user.admin?
      flash[:notice] = "Sorry, but you must be an administrator to access this page"
      redirect_to account_url
      return false
    else
      flash[:notice] = "You must be logged in and an administrator to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_ozmin_user
    if current_user && current_user.ozmin?
      return true
    elsif current_user && !current_user.ozmin?
      flash[:notice] = "Sorry, but you must have OZMIN access to view this page"
      redirect_to account_url
      return false
    else
      flash[:notice] = "You must be logged in and have OZMIN access to view this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def admin_is_logged_in?
    current_user && current_user.admin?
  end


end
