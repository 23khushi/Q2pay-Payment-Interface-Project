class User < ApplicationRecord
    
    has_many :accounts
    has_many :payments
    has_many :otps
  
    has_secure_password

    attribute :status, :boolean, default: false

    validates :aadhar_no, presence: true, uniqueness: {message: "Already registered"}, numericality: true, length: {maximum:12}
    
    validates :pan_no, uniqueness: {message: "Already registered"}, format: {with: /\A[A-Z]{3}[PCHFTABGJLE]{1}[A-Z]{1}[0-9]{4}[A-Z]{1}\z/, message: ' is invalid'}
    
    validates :mobile_no, presence:true, uniqueness: {message: "Already registered"}, numericality: true, length: {maximum:10}
    
    validates :first_name, presence: true, format: {with: /\A[A-Za-z]*\z/, message: 'should only contain letters'}

    validates :last_name, presence: true, format: {with: /\A[A-Za-z]*\z/, message: 'should only contain letters '}

    validates :email_id, presence: true, uniqueness: {message: "Already registered"}, format:{with: URI::MailTo::EMAIL_REGEXP, message: "Invalid mail id!"}
    

end
