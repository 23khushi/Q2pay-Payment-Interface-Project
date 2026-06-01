class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :bank, null: false, foreign_key: true
      t.bigint :acc_no
      t.string :acc_type
      t.bigint :balance
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :accounts, :acc_no, unique: true
  end
end
