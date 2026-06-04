class UsersController < ApplicationController
before_action :set_params, only: [:show, :update]
skip_before_action :authenticate_user, :authorize, only: [:create, :login]
skip_before_action :verification_process, only: [:login, :create, :verify_aadhar]

  def index
    if current_user.role == 'admin' || current_user.role == 'super_admin'
      @users = User.all.where.not(role: "admin")
    end
    render 'index', status: :ok
  end

  def show
    render 'show', status: :ok
  end

  def create
    begin
      @user =  User.new(user_params)
      @bank = Bank.find_by(bank_params)
      account = @user.accounts.where(account_params).build(bank_id: @bank.id)
      if @user.save
        render :create , status: :created
        UserMailer.welcome_email(@user).deliver_now
      else
        render json: {errors: @user.errors.full_messages + account.errors.full_messages + @bank.errors.full_messages}, status: :unprocessable_entity
      end
    rescue 
      render json: {errors: "Bank ifsc invalid"}, status: :unprocessable_entity
    end
  end


  def verify_aadhar
    aadhar_data = AadharVerificationLookup.find_aadhar(params[:aadhar_no])
    begin
      if aadhar_data.present?
        if aadhar_data[:mobile_no] == params[:mobile_no].to_i
          current_user.update(status: true)
          render json:{message: "Verified"}, status: :ok 
        else
          render json:{errors: "Invalid mobile number"} , status: :unprocessable_entity 
        end
      else
        render json: {errors: "Invalid aadhar number"}, status: :unprocessable_entity
      end
    rescue
      render json: {errors: "Something went wrong"}, status: :unprocessable_entity
    end
  end


  def login
    @user = UserLogin.login(params[:email_id], params[:password])
    if @user[:success]
      token = @user[:token]
      render json: {message: "Login Successful", token: token}, status: :ok
    else
      if @user[:message].present?
        render json: {errors: @user[:message]}, status: :unprocessable_entity
      end
    end
  end

  def update
    if @user.update(user_params)
      ActivityLog.create_log(@user, "updated", @user)
      render 'update' , status: :ok
    else
      render json: { errors: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end    
 

  private 

  def user_params
    params.permit(:aadhar_no, :pan_no, :mobile_no, :first_name, :last_name, :email_id, :password, :password_confirmation)
  end

  def account_params
    params.permit(:acc_type, :balance)
  end
  def bank_params
    params.permit(:ifsc)
  end

  def set_params
    if current_user.role == 'admin' || current_user.role == 'super_admin'
      @user =  User.find_by(id: params[:id])
    else
      @user = current_user
    end
    unless @user.present?
      render json: {errors: "User not found" }, status: :not_found
    end
  end
end
