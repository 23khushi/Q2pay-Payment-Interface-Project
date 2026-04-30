class CreateOtps < ActiveRecord::Migration[8.1]
  def change
    create_table :otps do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.integer :otp
      t.string :purpose
      t.datetime :expiry
      t.boolean :is_used
      t.timestamps
    end
  end
end
