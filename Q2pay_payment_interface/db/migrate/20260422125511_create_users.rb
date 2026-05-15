class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users,  id: :uuid do |t|
      t.string :aadhar_no, index: {unique: true}, null: false
      t.string :pan_no, index: {unique: true}, null: false
      t.bigint :mobile_no, index: {unique: true}, null: false
      t.string :first_name, null:false
      t.string :last_name, null:false
      t.string :email_id , index: {unique: true}, null: false
      t.string :password_digest
      t.boolean :status
      t.timestamps
    end
  end
end
