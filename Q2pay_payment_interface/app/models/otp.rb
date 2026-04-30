require 'securerandom'
class Otp < ApplicationRecord
  belongs_to :user

  validates :otp, presence: true, numericality: true

 
  def self.generate_otp(user, purpose)
    code = SecureRandom.rand(1000..9999)

    otp = user.otps.create!(
      user_id: user.id,
      otp: code,
      purpose: purpose,
      expiry: 5.minutes.from_now,
      is_used: false
    )

   
  end

  def self.verify_otp(user, purpose, user_otp)
    otp_details = user.otps.where(purpose: purpose, is_used: false).where("expiry  > ?", Time.current).last

    raise "Invalid or Otp expired " if otp_details.nil?

    raise "Wrong Otp" unless otp_details.otp ==  user_otp

    otp_details.update!(is_used: true)
  end



end
