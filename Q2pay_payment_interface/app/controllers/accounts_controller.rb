class AccountsController < ApplicationController
 
  def index
    @user_accounts = current_user
    render 'index', status: :ok
  end


  def create
    @user = current_user
    if @user.present?
      @bank = Bank.find_by(ifsc: params[:ifsc])
      @account = @user.accounts.build(acc_type: account_params[:acc_type], balance: account_params[:balance], bank_id: @bank.id )
      if @account.save 
        render json: {message: "Account created for existing user"}, status: :ok
      else
        render json: {errors: @account.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {errors: "User not found!"}, status: :not_found
    end
  end

  def destroy
    @account = current_user.accounts.find_by(id: params[:id])
    if @account
      @account.softdelete
      render json: {message: "Account deleted for id #{params[:id]}"}, status: :ok
    else
      render json: {errors: 'Account doesnt exists'}, status: :unprocessable_entity
    end
  end

  private
  def account_params
    params.permit(:acc_type, :balance)
  end
end
