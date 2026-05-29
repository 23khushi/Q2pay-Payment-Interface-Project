class ApplicationController < ActionController::API
 before_action :authenticate_user

  def current_user
   @current_user
  end
 
  private
  def authenticate_user
    begin
      header = request.headers['Authorization'] 
      token = header.split(' ').last if header
      decode = JsonWebToken.decode(token)
      if decode
        @current_user = User.find_by(id: decode[:id])
      else
        render json:{message: "Unauthorized user"}, status: :unauthorized
      end
    rescue
      render json: {errors: 'Token expired'}, status: :unprocessable_entity
    end
  end
end
