require 'securerandom'
class Otp < ApplicationRecord
  belongs_to :user

  validates :otp, presence: true, numericality: true, length: {maximum: 4}

 
  def self.generate_otp(user)
    code = SecureRandom.rand(1000..9999)

    otp = user.otps.create!(
      user_id: user.id,
      otp: code,
      expiry: 5.minutes.from_now,
      is_used: false
    )
    
    pp otp.otp

   
  end

  def self.verify_otp(user, user_otp)
    otp_details = user.otps.where(is_used: false).where("expiry  > ?", Time.current).order(created_at: :desc).first

    raise "Invalid or Otp expired " if otp_details.nil?

    raise "Wrong Otp" unless otp_details.otp ==  user_otp

    otp_details.update!(is_used: true)
  end



end
