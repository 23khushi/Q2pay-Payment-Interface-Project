class CreateBanks < ActiveRecord::Migration[8.1]
  def change
    create_table :banks do |t|
      t.string :ifsc
      t.integer :bank_id
      t.string :branch
      t.string :address
      t.string :city
      t.string :state
      t.string :bank_name

   
    end
    add_index :banks, :ifsc, unique: true
  end
end