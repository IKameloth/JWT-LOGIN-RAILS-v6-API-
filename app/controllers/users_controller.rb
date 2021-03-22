class UsersController < ApplicationController
  before_action :authenticate_request!, except: [:create, :login]
  before_action :set_user, only: [:show, :update, :destroy]

  # register
  def create
    @user = User.new(user_params)

    if @user.save && @user.authenticate(user_params[:passwrod])
      auth_token = JsonWebToken.encode(user_id: @user.id)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # login
  def login
    @user = User.find_by(email: user_params[:email].to_s.downcase)

    if @user&.authenticate(user_params[:password])
      auth_token = JsonWebToken.encode(user_id: @user.id)
      render json: { user: @user, auth_token: auth_token }, status: :ok
    else
      render json: { error: 'Invalid username/password' }, status: :unauthorized
    end
  end

  # def index
  #   @users = User.all

  #   render json: @users, status: :ok
  # end

  # def show
  #   render json: @user, status: :ok
  # end

  # def update
  #   if @user.update(user_params)
  #     render json: @user
  #   else
  #     render json: @user.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   @user.destroy
  # end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :age)
  end
end
