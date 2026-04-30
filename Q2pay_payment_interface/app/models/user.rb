class User < ApplicationRecord
    has_many :accounts
    has_many :transactions
    has_many :otps
    
    validates :aadhar_no, presence: true, uniqueness: {message: "Already registered"}, format: { with: /\A[2-9]{1}[0-9]{11}\z/ , message: 'invalid, must be of 12 digits'}
    
    validates :pan_no, uniqueness: {message: "Already registered"}, format: {with: /\A[A-Z]{3}[PCHFTABGJLE]{1}[A-Z]{1}[0-9]{4}[A-Z]{1}\z/, message: ' is invalid'}
    
    validates :mobile_no, presence:true, uniqueness: {message: "Already registered"}, format: {with: /\A[2-9]{1}[0-9]{9}\z/, message: 'invalid, must be of 10 digits only'}
    
    validates :first_name, presence: true, format: {with: /\A[A-Za-z]*\z/, message: 'should only contain letters'}

    validates :last_name, presence: true, format: {with: /\A[A-Za-z]*\z/, message: 'should only contain letters '}
    
    validates :pin, presence: true, format: {with: /\A[0-9]{4}\z/ , message: 'should be only 4 digits'}

end
