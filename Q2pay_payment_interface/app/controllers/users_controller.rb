class UsersController < ApplicationController
before_action :send_otp, only: [:send_otp]
before_action :verify_otp, only: [:verify_otp]
  def index
      @users = User.all
      render 'index'
  end

  def show
    
  end



  def create
    ActiveRecord::Base.transaction do
      @user = User.find_by(user_params)
      @bank = Bank.find_or_create_by!(bank_params)
      if @user.present?
        @account = @user.accounts.create!(account_params.merge(bank: @bank))
        render json: 'Account created for existing user'
      else 
        @user = User.create!(user_params)
        @account = @user.accounts.create!(account_params.merge(bank: @bank))
        render json: 'User created!!'
      end
    end
    rescue => e
      render json: {errors: e.message}
  end


  def destroy
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      render json: 'Updated successfully!'
    else
      render json:{errors: @user.errors.full_messages}
    end
  end

  def find_user
    if params[:aadhar_no].present?
      @user = User.find_by(aadhar_no: params[:aadhar_no])
    elsif params[:pan_no].present?
      @user = User.find_by(pan_no: params[:pan_no])
    elsif params[:mobile_no].present?
      @user = User.find_by(mobile_no: params[:mobile_no])
    else
      nil
    end
  end

  def send_otp
   user = find_user
    return render json: "User not found " unless user
    otp = Otp.generate_otp(user, params[:purpose])
    pp otp
    render json: {message: "Otp sent for #{params[:purpose]}: #{otp.otp}"}
  end

  def verify_otp
    user_verify = find_user
    return render json: "User not found " unless user_verify

    Otp.verify_otp(user_verify,params[:purpose], params[:otp] )
    render json: {message: "Otp successfully verified for #{params[:purpose]}"}
  end

  private 

  def user_params
    params.permit(:aadhar_no, :pan_no, :mobile_no, :first_name, :last_name, :pin )
  end

  def account_params
    params.permit(:acc_type, :balance)
  end

  def bank_params
    params.permit(:bank_name, :ifsc_code)
  end

  
end
