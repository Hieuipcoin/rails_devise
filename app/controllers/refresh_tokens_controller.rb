class RefreshTokensController < ApplicationController

  def show
    # use for get name of model class related to this controller
    @model_name = controller_path.classify
    puts "Riki test RefreshTokensController : #{@model_name}"

    request_refresh_token = request.headers['refresh-token']

    # check empty refresh token
    if request_refresh_token.blank?
      return render json: {
          status: 'ERROR',
          message: "refresh token is empty",
          data: nil
      }, status: :bad_request
    end

    # check begin must be "Bearer "
    if request_refresh_token.start_with?("Bearer ")
      request_refresh_token.slice!(0, "Bearer ".length)
    else
      return render json: {
          status: 'ERROR',
          message: 'refresh token must begin with string "Bearer "',
          data: nil
      }, status: :bad_request
    end


    puts "riki check : #{request_refresh_token}"


    decoded_request_token = Warden::JWTAuth::TokenDecoder.new.call(request_refresh_token)
    if decoded_request_token['exp'] <= Time.now.to_i
      return render json: {
          status: 'ERROR',
          message: "refresh token is expired",
          data: nil
      }, status: :unprocessable_entity
    end


    puts "aa: #{request_refresh_token}"
    begin

      user_record = RefreshToken.find_by!(refresh_token: request_refresh_token)
      puts "abcd #{user_record.id}"

      # generate new access token
      # done later

      #generate new refresh token
      refresh_token = create_refresh_token(user_record.id, 1.day.to_i)

      response.headers['refesh_token'] = "Bearer #{refresh_token}"

      render json: {
          status: 'SUCCESS',
          message: "updated token",
          name: user_record.name,
          email: user_record.email
      }, status: :ok

    rescue ActiveRecord::RecordNotFound
      return render json: {
          status: 'ERROR',
          message: "refresh token is not found",
          data: nil
      }, status: :not_found
    end














    # begin
    #   user_record = RefreshToken.where(refresh_token: request_refresh_token)
    #   puts user_record.name
    #   puts user_record.first.name
    #   puts user_record.first.email
    #
    #   db_refresh_token = user_record.first.refresh_token
    #
    #   if db_refresh_token == request_refresh_token
    #     decoded_token = Warden::JWTAuth::TokenDecoder.new.call(db_refresh_token)
    #     puts "RIKI here !!!! #{decoded_token}"
    #     decoded_token2 = decodeaaa(db_refresh_token)
    #     puts "RIKI here2 !!!! #{decoded_token2}"
    #   else
    #     # do something
    #   end
    #
    # rescue ActiveRecord::RecordNotFound
    #   puts "riki I cant find user related to refresh token"
    # end

  end


  private

  def decodeaaa(token)
    key = ENV['DEVISE_JWT_SECRET_KEY']
    algorithm = 'HS256'
    JWT.decode(token, key, algorithm: algorithm, verify_jti: true)
  end

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