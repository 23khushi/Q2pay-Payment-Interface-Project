json.array! @pay do |pay|
    json.extract! pay, :source_accno, :amount, :receiver_accno
end