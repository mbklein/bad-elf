class SessionsController < ApplicationController
  def new
    session[:return_path] = params[:return_path]
  end

  def create
    user = User.find_or_create_by_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    return_path = session.delete(:return_path) || root_url
    redirect_to return_path, :notice => "Signed in!"
  end

  def destroy
    session.delete('user_id')
    redirect_to root_url, :notice => "Signed out!"
  end
end
