class Api::ApiController < ApplicationController
  before_action :authenticate

  def authenticate
    access_token = params[:access_token]
    kid = Kid.where(access_token: access_token).first
    render json: {status: :unathorized} and return false unless kid

    if kid && kid.has_expired_token?
      kid.update_column(:token_expiration_time, DateTime.now + 5.minutes)
      render json: {status: :unathorized} and return false
    else
      kid.update_column(:token_expiration_time, DateTime.now)
    end
  end
end
