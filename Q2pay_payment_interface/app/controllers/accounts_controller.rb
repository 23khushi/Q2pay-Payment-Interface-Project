class AccountsController < ApplicationController
   before_action :add_money

  

  def index
     if params[:aadhar_no].present?
        @user_accounts = User.includes(:accounts).where(aadhar_no: params[:aadhar_no]) 
      end

      if params[:pan_no].present?
        @user_accounts = User.includes(:accounts).where(pan_no: params[:pan_no])
      end

      if params[:mobile_no].present?
        @user_accounts = User.includes(:accounts).where(mobile_no: params[:mobile_no])
      end

      render :index
  end

  def show

  end

  def update

  end

  def destroy
    @account = Account.find_by(id: params[:id])
    if @account.softdelete
      render json: "Account deleted for id #{params[:id]}"
    else
      render json: {errors: 'Not found'}
    end
  end






end
