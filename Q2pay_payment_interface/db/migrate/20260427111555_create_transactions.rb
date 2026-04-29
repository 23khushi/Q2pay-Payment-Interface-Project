class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :source_acc, null: false, foreign_key: { to_table: :accounts }
      t.references :receiver_acc, null: false, foreign_key: { to_table: :accounts }
      t.bigint :amount
      t.string :receiver_accno
      t.string :receiver_acc_type
      t.string :receiver_name
      t.string :receiver_ifsc
      t.string :receiver_bank_name

      t.timestamps
    end
  end
end
