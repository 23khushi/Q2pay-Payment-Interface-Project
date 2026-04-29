class Account < ApplicationRecord
  belongs_to :user
  belongs_to :bank
  has_many :transactions
  default_scope -> {where(deleted_at: nil)}
  require 'securerandom'
  
  before_validation :acctype_to_downcase
  before_validation :balance_accordingto_acctype
  before_create :generate_account_number
  VALID_ACCOUNT_TYPE = ['saving', 'current']
  validates :acc_type, presence: true, inclusion:{in: VALID_ACCOUNT_TYPE, message: 'is invalid'}, uniqueness: {scope: [:user_id, :bank_id], message:  'with this user already exists '}
  validates :balance, presence: true, numericality: { in: 1..99999999}



  def softdelete
    update(deleted_at: Time.current)
  end



  def transfer(data)
    ActiveRecord::Base.transaction do
      destination_account = Account.find_by(acc_no: data[:receiver_accno])
      raise "Destination account does not exist!" unless destination_account.present?
      
      raise "cannot transfer to same account" if self.id == destination_account.id
      raise "Not enough balance" if data[:amount] > self.balance

      self.update!(balance: balance - data[:amount])
      destination_account.update!(balance: destination_account[:balance] + data[:amount])

      pp user_id
      pp self.user_id 
      Transaction.create!(
        source_acc_id: self.id,
        user_id: user_id,
        receiver_acc_id: destination_account.id,
        amount: data[:amount],
        receiver_accno: data[:receiver_accno],
        receiver_acc_type: destination_account.acc_type,
        receiver_name: destination_account.user.first_name,
        receiver_ifsc: destination_account.bank.ifsc_code, 
        receiver_bank_name: destination_account.bank.bank_name
      )
    end
    rescue => e
    errors.add(:base, e.message)
    false
  end
  

  private

  def acctype_to_downcase
    self.acc_type = acc_type.downcase
  end

  def balance_accordingto_acctype
    if acc_type == 'saving' && balance < 100
      errors.add(:balance, 'must be greater than 100 for saving account')
    elsif acc_type == 'current' && balance < 500
      errors.add(:balance, 'must be greater than 500 for current account')
    else
      return
    end
  end

  def generate_account_number
    acc_no = SecureRandom.rand(10**8)
    self.acc_no = acc_no
  end
end
