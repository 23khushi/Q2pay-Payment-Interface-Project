class Bank < ApplicationRecord
  has_many :accounts

  before_validation :valid_ifsc_code

  validates :bank_name,:address,:branch,:city,:district,:state,  presence: true
  
  validates :ifsc, presence: true, length: {maximum: 11}


  private

   def valid_ifsc_code
    actual_ifsc = Bank.includes?(ifsc)
    unless actual_ifsc.present?
     errors.add(:ifsc_code,"is invalid")
    end
   end
end
