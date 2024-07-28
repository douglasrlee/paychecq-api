# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :handle_not_authorized_error

  def current_user
    fetch_client
  end

  private

  def fetch_client
    return unless request.authorization.present? && (request.authorization.split(' ', 2).first == 'Basic')

    client_id, client_secret = ActionController::HttpAuthentication::Basic.user_name_and_password(request)

    client = Client.find_by(id: client_id)

    return unless AuthenticationService.valid_secret?(client_secret, client.hashed_secret)

    client
  end

  def handle_not_authorized_error
    head :unauthorized
  end
end
