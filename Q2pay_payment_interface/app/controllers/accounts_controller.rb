class AccountsController < ApplicationController
  

  

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

  def transfer_money
    @account = Account.find_by(acc_no: params[:source_accno])
    pp @account
    if @account.present?
      if @account.transfer(transfer_params)
        render json: 'Transaction successfull'
      else
        render json: {errors: @account.errors.full_messages}
      end
    else
      render json:"Account not present with account id #{params[:id]}"
    end

  end


  private

  def transfer_params
    params.permit(:amount, :receiver_accno)
  end

end
