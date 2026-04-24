class Bank < ApplicationRecord
  has_many :accounts

 
  BANK_NAME = ['hdfc', 'icici']
  IFSC_CODE_INITIALS = ['HDFC','ICIC']

  before_validation :baank_name_downcase, :valid_ifsc_code

  validates :bank_name, presence: true, inclusion: BANK_NAME
  
  validates :ifsc_code, presence: true, length: {maximum: 11}


  private

  def baank_name_downcase
    self.bank_name = bank_name.downcase
  end

   def valid_ifsc_code
    ifsc = ifsc_code[0,4]
    code = ifsc_code[4]
    pp code
    unless IFSC_CODE_INITIALS.include?(ifsc) || code == 0
      errors.add(:ifsc_code,"is invalid for bank #{bank_name}")
    end
   end
end
