class Bank < ApplicationRecord
  has_many :accounts

 
  BANK_NAME = ['hdfc', 'icici']
  BANK_MAPPED_IFSC = {
    'hdfc' => 'HDFC',
    'icici' => 'ICIC'
  }

  before_validation :baank_name_downcase, :valid_ifsc_code

  validates :bank_name, presence: true, inclusion: BANK_NAME
  
  validates :ifsc_code, presence: true, length: {maximum: 11}


  private

  def baank_name_downcase
    self.bank_name = bank_name.downcase
  end

   def valid_ifsc_code
    actual_ifsc = BANK_MAPPED_IFSC[bank_name]
    ifsc_initial = ifsc_code[0,4]
    code = ifsc_code[4]
    unless actual_ifsc == ifsc_initial || code == 0
      errors.add(:ifsc_code,"is invalid for bank #{bank_name}")
    end
   end
end
