json.array! @user_accounts do |user_account|
    json.partial! 'accounts', user: user_account
end