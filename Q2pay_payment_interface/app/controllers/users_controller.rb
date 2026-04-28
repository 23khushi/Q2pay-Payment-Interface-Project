class UsersController < ApplicationController

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
