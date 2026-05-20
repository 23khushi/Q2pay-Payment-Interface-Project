class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :user,:source_user, type: :uuid, null: false, foreign_key: true
      t.references :source_acc, null: false, foreign_key: { to_table: :accounts }
      t.references :receiver_acc, null: false, foreign_key: { to_table: :accounts }
      t.bigint :amount
      t.timestamps
    end
  end
end
