class ApplicationController < ActionController::API
 before_action :authenticate_user
 before_action :authorize
 before_action :verification_process

  def current_user
   @current_user
  end

  private
  def authenticate_user
    begin
      header = request.headers["Authorization"]
      token = header.split(" ").last if header
      decode = JsonWebToken.decode(token)
      if decode
        @current_user = User.find_by(id: decode[:id])
      else
        render json: { message: "Unauthorized user" }, status: :unauthorized
      end
    rescue
      render json: { errors: "Token expired" }, status: :unprocessable_entity
    end
  end

  def authorize
    service =  AuthorizeUser.new(self, action_name)
    unless service.allowed?
      render json: { errors: "You are not authorized to perform this action" }, status: :forbidden
    end
  end

  def verification_process
    unless current_user.status == true
      render json: { errors: "Verification is pending! please complete the verification process first." }, status: :unprocessable_entity
    end
  end
end
