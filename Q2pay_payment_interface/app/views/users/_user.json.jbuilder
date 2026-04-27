json.extract! user
json.first_name user.first_name
json.last_name user.last_name
json.aadhar_no user.aadhar_no
json.accounts user.accounts do |account|
    json.account_type account.acc_type
    json.balance account.balance
    bank = account.bank
    json.bank_name bank.bank_name.upcase
    json.ifsc_code bank.ifsc_code    
end
