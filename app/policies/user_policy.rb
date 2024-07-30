# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def create?
    @user.is_a?(Client) && super
  end
end
