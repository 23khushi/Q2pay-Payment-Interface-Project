 json.extract! payment
 json.source_account_number payment.source_account.acc_no
 json.amount payment.amount
 if @current_user.id == payment.receiver_account.user_id
    json.operation "credit" 
 end

if @current_user.id == payment.source_account.user_id
   json.operation "debit" 
end
json.receiver_account_number payment.receiver_account.acc_no
json.activity_logs payment.activity_logs do |log|
   json.id log.id
   json.action log.action
   json.created_at log.created_at
end