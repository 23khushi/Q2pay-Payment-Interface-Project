class Account < ApplicationRecord
  belongs_to :user
  belongs_to :bank
  require 'securerandom'
  
  before_validation :acctype_to_downcase
  before_validation :balance_accordingto_acctype
  # after_validation :balance_accordingto_acctype
  before_create :generate_account_number
  VALID_ACCOUNT_TYPE = ['saving', 'current']
  validates :acc_type, presence: true, inclusion:{in: VALID_ACCOUNT_TYPE, message: 'is invalid'}, uniqueness: {scope: [:user_id, :bank_id], message:  'with this user already exists '}
  validates :balance, presence: true, numericality: { in: 1..99999999 }



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
