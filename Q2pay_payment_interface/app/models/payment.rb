class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :source_account, class_name: 'Account', foreign_key: 'source_acc_id'
  belongs_to :receiver_account, class_name: 'Account', foreign_key: 'receiver_acc_id'


  before_validation :amount_cant_be_negative

  validates :user_id, :source_acc_id,:receiver_acc_id, :receiver_accno, :receiver_acc_type, :receiver_name, :receiver_ifsc, :receiver_bank_name, :amount, presence: true
  
  validates :amount, numericality: true


  def amount_cant_be_negative
    return errors.add(:amount, "Invalid ") if amount <= 0
  end
  

  def transfer(data)
    destination_account = Account.find_by(acc_no: data[:receiver_accno])
    source_account = Account.find_by(acc_no: data[:source_accno])
    data[:amount] = data[:amount].to_i
    unless destination_account.present? 
      errors.add(:base, "Destination account does not exist!") 
      return 
    end
    unless source_account.present? 
      errors.add(:base, "Source account does not exist!") 
      return 
    end
    if source_account.id == destination_account.id
      errors.add(:base, "cannot transfer to same account")  
      return 
    end
    if data[:amount] > source_account.balance 
      errors.add(:base,  "Not enough balance")
      return 
    end
    source_account.update!(balance: source_account[:balance] - data[:amount])
    destination_account.update!(balance: destination_account[:balance] + data[:amount])
    payment = Payment.create(
      source_acc_id: source_account.id,
      user_id: source_account.user_id,
      receiver_acc_id: destination_account.id,
      source_accno: source_account.acc_no,
      amount: data[:amount],
      receiver_accno: data[:receiver_accno],
      receiver_acc_type: destination_account.acc_type,
      receiver_name: destination_account.user.first_name,
      receiver_ifsc: destination_account.bank.ifsc, 
      receiver_bank_name: destination_account.bank.bank_name
    )
    unless payment.save
      errors.add(:base, payment.errors.full_messages.join())
      return false
    end

    true
  end  
end
