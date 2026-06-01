class AccountsController < ApplicationController
 
  def index
    if current_user.role == 'admin' || current_user.role == 'super_admin'
      @accounts = Account.all
    else
      @accounts = current_user.accounts
      pp @accounts
    end
    render 'index', status: :ok
  end


  def create
    @user = current_user
    if @user.present?
      @bank = Bank.find_by(ifsc: params[:ifsc])
      @account = @user.accounts.build(acc_type: account_params[:acc_type], balance: account_params[:balance], bank_id: @bank.id )
      if @account.save 
        ActivityLog.create_log(current_user, "created", @account)
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
      ActivityLog.create_log(current_user, "deleted", @account)
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
