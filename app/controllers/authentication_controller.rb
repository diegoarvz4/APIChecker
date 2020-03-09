class AuthenticationController < ApplicationController

  skip_before_action :authorize_request, only: :create

  def create
    auth_token = AuthenticateUser.new(auth_params[:username], auth_params[:password ]).call
    render json: { auth_token: auth_token }, status: :ok
  end

  private 

  def auth_params
    params.permit(:username, :password)
  end
end