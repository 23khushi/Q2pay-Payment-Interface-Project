class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :account

  BANK_OPERATION = ['credit', 'debit']

  before_validation :operation_to_downcase

  validates :user_id, :account_id, :operation, :amount, presence: true
  
  validates :amount, numericality: {in: 1..99999999 }
  
  validates :operation , inclusion: BANK_OPERATION
  


  def operation_to_downcase
    self.operation = operation.downcase
  end

 
end
