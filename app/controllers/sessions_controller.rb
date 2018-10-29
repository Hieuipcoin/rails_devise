require 'authenticatable/authenticatable'


class SessionsController < Devise::SessionsController
  respond_to :json
  LIMIT_UPDATE_TIME = 2 # 1 seconds

  # POST /users/sign_in
  def create
    super

    # create refresh token
    refresh_token = create_refresh_token self.resource.id, 1.day.to_i

    # save to database
    # set refresh token to nil if can't update database
    start_second = Time.now
    loop do
      if self.resource.update_attributes(refresh_token: refresh_token)
          break
      elsif (Time.now - start_second) >= LIMIT_UPDATE_TIME
        refresh_token = nil
          break
        end
      sleep 1
    end

    # attach refresh token to respond header and body
    response.headers['refesh_token'] = "Bearer #{refresh_token}"
  end

  private

  def create_refresh_token(user_id, expiration_time)
    current_time = Time.now.to_i
    payload = {
        'jti' => SecureRandom.uuid,
        'aud' => nil,
        'iat' => current_time,
        'sub' => user_id,
        'exp' => current_time + expiration_time
    }
    key = ENV['DEVISE_JWT_SECRET_KEY']
    algorithm = 'HS256'

    JWT.encode(payload, key, algorithm)
  end

end
