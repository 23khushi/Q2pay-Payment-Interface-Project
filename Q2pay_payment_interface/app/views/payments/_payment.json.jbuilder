 
 json.id payment.id
 json.source_account_number payment.source_account.acc_no
 json.amount payment.amount
 if @current_user.id == payment.receiver_account.user_id
    json.operation "credit" 
 else
   json.operation "debit" 
end
json.receiver_account_number payment.receiver_account.acc_no
json.activity_logs payment.activity_logs do |log|
   json.action log.action
   json.created_at log.created_at
end





# ----  for building the activity logs for existing payments which had empty activity logs

#  payments.each do |p|
#    log = p.activity_log 
#    if log.blank?
#      update_log =  ActivityLog.new()
#      update_log.action = "created"
#      update_log.loggable = p
#      update_log.user_id = p.source_account.user_id
#      update_log.save
#    end
#  end


