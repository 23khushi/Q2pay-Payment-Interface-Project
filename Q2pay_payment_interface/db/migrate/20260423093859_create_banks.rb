class CreateBanks < ActiveRecord::Migration[8.1]
  def change
    create_table :banks do |t|
      t.string :bank_name
      t.string :ifsc_code

      t.timestamps
    end
    add_index :banks, :ifsc_code, unique: true
  end
end