
json.extract! user
json.full_name user.first_name + " " + user.last_name
account = user.accounts.last
bank = account.bank
json.bank_name bank.bank_name
json.ifsc_code bank.ifsc_code