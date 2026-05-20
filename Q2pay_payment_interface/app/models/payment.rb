class Payment < ApplicationRecord
  belongs_to :source_user, class_name: 'User', foreign_key: 'source_user_id'
  belongs_to :source_account, class_name: 'Account', foreign_key: 'source_acc_id'
  belongs_to :receiver_account, class_name: 'Account', foreign_key: 'receiver_acc_id'


  before_validation :amount_cant_be_negative

  validates :source_user_id, :source_acc_id,:receiver_acc_id, :amount, presence: true
  
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
    payment = Payment.create!(
      source_acc_id: source_account.id,
      source_user_id: source_account.user_id,
      receiver_acc_id: destination_account.id,
      amount: data[:amount]
    )
    true
  end  
  
  def self.fetch_index(params, current_user)
    payments = Payment.where('source_user_id IN (?) OR receiver_acc_id IN (?) ', current_user.id, current_user.accounts.ids)
    if params[:minimum].present?
      payments = current_user.payments.where('amount >= ?', params[:minimum])
    end
    if params[:maximum].present?
      payments = current_user.payments.where('amount <= ?', params[:maximum])
    end
    if params[:operation].present?
      if params[:operation].downcase == 'credit'
        payments = Payment.where(receiver_acc_id: current_user.accounts.ids)
      elsif params[:operation].downcase == 'debit'
        payments = Payment.where(source_acc_id: current_user.accounts.ids)
      else
        raise "Invalid Operation"
      end
    end
    payments
  end
end
