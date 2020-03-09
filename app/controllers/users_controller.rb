class UsersController < ApplicationController
  before_action :admin?, only: :show
  skip_before_action :authorize_request, only: :create

  def index
    user = User.all
    render json: user, status: :ok
  end

  def show
    user = User.find(params[:id])
    render json: user,
      include: {
        access_reports: {
          except: [ :created_at, :updated_at ]
        }
      },
      except: [:created_at, :updated_at],
      status: :ok
  end

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.username, user.password).call
    response = { message: "Account Created", auth_token: auth_token }
    render json: response, status: :created # 201
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :password, :password_confirmation)
  end

  def admin?
    current_user.admin?
  end
end
