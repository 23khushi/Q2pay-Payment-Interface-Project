# json.total_payment_count @total_counts

# json.array! @payments do |payment|
#     json.partial! 'payment', payment: payment
# end

if @payments.present?
    json.Total_Transactions @payments.count
    json.Transactions do
        json.array! @payments do |payment|
        json.partial! 'payment', payment: payment
        end
    end
else
    json.Total_Transactions 0
end