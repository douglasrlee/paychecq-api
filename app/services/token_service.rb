# frozen_string_literal: true

class TokenService
  ACCESS_TOKEN_LIFETIME = 60 * 60 * 24      # 1 Day
  ID_TOKEN_LIFETIME     = 60 * 60 * 24 * 30 # 30 Days

  ACCESS_TOKEN = 'access_token'
  ID_TOKEN     = 'id_token'

  def self.access_token(user, client)
    JwtService.encode({
                        sub: user.id,
                        aud: client.id,
                        exp: Time.now.utc.to_i + ACCESS_TOKEN_LIFETIME,
                        typ: ACCESS_TOKEN,
                        iss: ENV.fetch('PAYCHECQ_API_HOST')
                      })
  end

  def self.id_token(user, client)
    JwtService.encode({
                        sub: user.id,
                        aud: client.id,
                        exp: Time.now.utc.to_i + ID_TOKEN_LIFETIME,
                        typ: ID_TOKEN,
                        iss: ENV.fetch('PAYCHECQ_API_HOST'),
                        name: user.name,
                        picture: "https://gravatar.com/avatar/#{Digest::SHA256.hexdigest(user.email)}?d=mp",
                        email: user.email,
                        updated_at: user.updated_at.to_i
                      })
  end
end
