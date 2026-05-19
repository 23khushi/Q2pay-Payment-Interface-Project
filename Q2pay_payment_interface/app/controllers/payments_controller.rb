class PaymentsController < ApplicationController

  def index
    @pay = Payment.all
    render :index, status: :ok
  end


  def create
    @account = current_user.accounts
    begin
      if @account
        @pay = Payment.new
        if @pay.transfer(payment_params)
          render json: {message: "Transaction successful"} , status: :ok
        else
          render json: {errors: @pay.errors.full_messages }, status: :unprocessable_entity
        end
      else 
        render json: {errors: "User Account does not exist"}, status: :unprocessable_entity
      end
     rescue
      render json: {message: "Something went wrong"}, status: :unprocessable_entity
    end
  end

  private
  def payment_params
    params.permit(:source_accno, :amount,:receiver_accno)
  end
end
