class PaymentsController < ApplicationController

  def index
    @pay = Payment.all
    render :index, status: :ok
  end


  def create
    @account = Account.find_by(acc_no: params[:source_accno])
    if @account.nil?
      render json: {errors: 'Source account doesnt exist!'}, status: :unprocessable_entity
      return
    end
    begin
      @pay = Payment.new
      if @pay.transfer(transaction_params)
        render json: {message: "Transaction successfull"} , status: :ok
      else
        render json: {errors: @pay.errors.full_messages }, status: :unprocessable_entity
      end
    rescue
      render json: {message: "Something went wrong"}, status: :unprocessable_entity
    end
  end

  private 
  def transaction_params
    params.permit(:source_accno, :amount, :receiver_accno)
  end
end
