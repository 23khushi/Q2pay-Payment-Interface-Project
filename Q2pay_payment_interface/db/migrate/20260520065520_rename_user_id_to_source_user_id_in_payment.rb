class RenameUserIdToSourceUserIdInPayment < ActiveRecord::Migration[8.1]
  def change
     rename_column :payments, :user_id, :source_user_id
  end
end
