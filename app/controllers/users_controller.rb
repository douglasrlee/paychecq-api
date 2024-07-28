# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.build(user_params)

    if @user.save
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
