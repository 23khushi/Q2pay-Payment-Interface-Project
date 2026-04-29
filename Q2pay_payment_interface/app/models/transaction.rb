class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :source_account, class_name: 'Account', foreign_key: 'source_acc_id'
  belongs_to :receiver_account, class_name: 'Account', foreign_key: 'receiver_acc_id'





  validates :user_id, :source_acc_id,:receiver_acc_id, :receiver_accno, :receiver_acc_type, :receiver_name, :receiver_ifsc, :receiver_bank_name, :amount, presence: true
  
  validates :amount, numericality: true
  
  
  



  
end
