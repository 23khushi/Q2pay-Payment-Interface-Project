class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.string :operation
      t.bigint :amount

      t.timestamps
    end
  end
end
