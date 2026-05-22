class AddReceiverUserIdToPayments < ActiveRecord::Migration[8.1]
  def change
    add_reference :payments, :receiver_user, type: :uuid, null: false, foreign_key: { to_table: :users }   
  end
end
