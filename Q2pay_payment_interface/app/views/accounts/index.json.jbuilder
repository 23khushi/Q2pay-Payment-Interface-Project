json.array! @user_accounts do |user_account|
    json.partial! 'account', user: user_account
end