class PaymentsController < ApplicationController

  def index
    @pay = Payment.all
    render :index, status: :ok
  end


  def create
    @account = current_user.accounts.pluck(:acc_no)
    @account = @account[0].to_i
    begin
      @pay = Payment.new
      if @pay.transfer(source_accno: @account, amount: params[:amount], receiver_accno: params[:receiver_accno])
        render json: {message: "Transaction successfull"} , status: :ok
      else
        render json: {errors: @pay.errors.full_messages }, status: :unprocessable_entity
      end
    rescue
      render json: {message: "Something went wrong"}, status: :unprocessable_entity
    end
  end

end
