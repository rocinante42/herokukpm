class Api::ApiController < ApplicationController

  def authenticate
    puts "estoy en aunthenticate"
    access_token = params[:access_token]
    puts access_token
    kid = Kid.where(access_token: access_token).first
    puts "kid: "
    puts kid
    render json: {status: :unathorized} and return false unless kid

    if kid && kid.has_expired_token?
      kid.update_column(:token_expiration_time, DateTime.now + 5.minutes)
      render json: {status: :unathorized} and return false
    else
      kid.update_column(:token_expiration_time, DateTime.now + 5.minutes)
    end
  end
end
