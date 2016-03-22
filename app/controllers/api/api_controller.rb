class Api::ApiController < ApplicationController

  def authenticate
    puts "estoy en aunthenticate"
    access_token = params[:access_token]
    puts access_token
    kid = Kid.where(access_token: access_token).first
    puts "kid a punto de nueva funcion"
    #new test code
    flag = params[:bichitos]
    if flag
      kid = Kid.where(access_token: params[:access_token]).first
      puts "kids where found on line 114"
      render json: {status: :nein} and return false unless kid
      kid.update_column(:token_expiration_time, DateTime.now + 5.minutes)
      puts "en medio de authenticate regresando el json"
      kids = Kid.where(classroom: kid.classroom).where.not(id: kid.id).to_a.sample(3)
      kids << kid
      render json: {kids: kids}
    end
    #test code
    render json: {status: :unathorized} and return false unless kid

    if kid && kid.has_expired_token?
      kid.update_column(:token_expiration_time, DateTime.now + 5.minutes)
      render json: {status: :unathorized} and return false
    else
      kid.update_column(:token_expiration_time, DateTime.now + 5.minutes)
    end
  end
end
