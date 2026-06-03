# json.extract! user
# json.name accounts.user.first_name.concat(" ", user.last_name)
 json.accounts_details accounts do |account|
  json.full_name "#{account.user.first_name} #{account.user.last_name}".strip
  json.account_number account.acc_no
  json.account_type account.acc_type
  json.balance account.balance
  json.bank_name  account.bank.bank_name.upcase
  json.ifsc_code  account.bank.ifsc  
  json.activity_logs account.activity_logs do |log|
    json.action log.action
    json.created_at log.created_at
    end 
  end