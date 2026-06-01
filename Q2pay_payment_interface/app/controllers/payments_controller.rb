class PaymentsController < ApplicationController

  def index
    if current_user.role == 'admin' || current_user.role == 'super_admin'
      @payments = Payment.all
    else
      @payments = Payment.fetch_index(fetch_params, current_user)
    end
    render :index, status: :ok
  end

  
  def create
    @account = current_user.accounts
    begin
      if @account    
        if Payment.transfer(payment_params,current_user)
          render json: {message: "Transaction successful"} , status: :ok
        else
          render json: {errors: @pay.errors.full_messages }, status: :unprocessable_entity
        end
      else 
        render json: {errors: "User Account does not exist"}, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: {errors: e.message}, status: :unprocessable_entity
    rescue => e
      render json: {errors: e.message}, status: :unprocessable_entity
    end
  end

  


  private
  def payment_params
    params.permit(:source_accno, :amount,:receiver_accno)
  end

  def fetch_params
    params.permit(:minimum, :maximum, :operation)
  end
end
