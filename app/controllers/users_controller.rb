# frozen_string_literal: true

class UsersController < ApplicationController
  before_action -> { authorize User }, only: [:create]

  def create
    @user = User.build(user_params)

    if @user.save
      response.headers['X-Access-Token'] = TokenService.access_token(@user, current_user)
      response.headers['X-Id-Token'] = TokenService.id_token(@user, current_user)

      render :create, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:name)
    params.require(:email)
    params.require(:password)

    params.permit(:name, :email, :password)
  end
end
