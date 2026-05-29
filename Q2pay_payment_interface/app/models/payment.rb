class Payment < ApplicationRecord
  belongs_to :source_account, class_name: 'Account', foreign_key: 'source_acc_id'
  belongs_to :receiver_account, class_name: 'Account', foreign_key: 'receiver_acc_id'
  has_many :activity_logs, as: :loggable
  before_validation :amount_cant_be_negative



  validates :amount, numericality: true, presence: true

  def amount_cant_be_negative
    return errors.add(:amount, "Invalid ") if amount <= 0
  end


  def self.transfer(data,current_user)
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
    @payment = Payment.create!(
      source_acc_id: source_account.id,
      receiver_acc_id: destination_account.id,
      amount: data[:amount]
    ) 
    true
    ActivityLog.create_log(current_user, "created", @payment) 
  end    
  
  def self.fetch_index(params, current_user)
    user_data = current_user.accounts
    pp  params
    pp "hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii"
    payments = Payment.where('source_acc_id IN (?) OR receiver_acc_id IN (?)', user_data.pluck(:id), user_data.pluck(:id))
    pp "hghgh"
    pp params[:minimum]
    pp "hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii"
    if params[:minimum].present?
      payments = payments.where('amount >= ?', params[:minimum])
    end
  
    if params[:maximum].present?
      payments = payments.where('amount <= ?', params[:maximum])
    end
  
    if params[:operation].present?
      case params[:operation].downcase
      when 'credit'
        payments = payments.where(receiver_acc_id: user_data.pluck(:id))
      when 'debit'
        payments = payments.where(source_acc_id: user_data.pluck(:id))
      else
        # raise "Invalid Operation"
      end
    end
    payments   
  end
end