json.extract! user
json.first_name user.first_name
json.last_name user.last_name
json.accounts_details user.accounts do |account|
    json.account_number account.acc_no
    json.account_type account.acc_type
    json.balance account.balance
    json.bank_name  account.bank.bank_name.upcase
    json.ifsc_code  account.bank.ifsc_code    
end