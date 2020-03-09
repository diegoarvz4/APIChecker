class UsersController < ApplicationController
  before_action :allowed?, only: [:index, :show]
  skip_before_action :authorize_request, only: :create

  def index
    user = User.all
    render json: user, 
      except: [:created_at, :updated_at, :password_digest, :admin],
      status: :ok
  end

  def show
    user = User.find(params[:id])
    render json: user,
      include: {
        access_reports: {
          except: [ :created_at, :updated_at, :employee_id]
        }
      },
      except: [:admin, :password_digest, :created_at, :updated_at],
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

  def allowed?
    unless current_user.admin
      render json: { message: 'Unauthorized', status: :unauthorized } if current_user.id.to_i != params[:id].to_i
    end
  end
end
