class TransactionsController < ApplicationController
    def create
        transaction = Transaction.new(transaction_params)
        if transaction.save
            render json: 'successs'
        else
            render json: {errors: transaction.errors.full_messages}
        end
    end

     private
     def transaction_params
        params.permit(:user_id, :account_id, :operation, :amount)
     end
end
