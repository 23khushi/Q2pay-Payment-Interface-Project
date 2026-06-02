require "test_helper"

class BankFlowTest < ActionDispatch::IntegrationTest

  test 'should create user' do
    post '/users.json',
    params: user_details,
    headers: { }  
    assert_equal "Riya pawar", json_response["full_name"]
    assert_equal "ABHYUDAYA COOPERATIVE BANK LIMITED", json_response["bank_name"]
    assert_equal "MOBILE BANK", json_response["branch_name"]
    assert_equal "ABHY0065017", json_response["ifsc_code"]
    assert_response :created
  end

  test 'should not create user if aadhar is already present' do
    post '/users.json',
    params: user_details.except(:aadhar_no).merge(aadhar_no: "667656565123"),
    headers: {}  
    assert_equal "Aadhar no Already registered", json_response["errors"][0]
    assert_response :unprocessable_entity
  end

  test 'should not create user if mobile no already present' do
    post '/users.json', 
    params: user_details.except(:mobile_no).merge(mobile_no: 8934376311),
    headers: {}
    assert_equal "Mobile no Already registered", json_response["errors"][0]
    assert_response :unprocessable_entity
  end

  test 'should not create user if pan no already present' do
    post '/users.json',
    params: user_details.except(:pan_no).merge(pan_no: "ECDPS2246Q"),
    headers: {}
    assert_equal "Pan no Already registered", json_response["errors"][0]
    assert_response :unprocessable_entity
  end

  test 'should not create user with existing email_id' do
    post '/users.json',
    params: user_details.except(:email_id).merge(email_id: "tina@gmail.com"),
    headers: {}
    assert_equal "Email Already registered", json_response["errors"][0]
    assert_response :unprocessable_entity
   end

    test 'should not create user if password and password confirmation doesnt match' do
      post '/users.json',
       params: user_details.except(:password_confirmation).merge(password_confirmation: "tinaa1234"),
      headers: {}
      assert_equal "Password confirmation doesn't match Password", json_response["errors"][0]
      assert_response :unprocessable_entity

    end


    test 'Registered user should be able to login' do
      post '/users/login?email_id=tina@gmail.com&password=tina123',
       params: {  },
      headers: {}
      assert_equal "Login Successful", json_response["message"]
      assert_response :ok
    end

    test 'User should not be able to login if credentials invalid' do
      post '/users/login?email_id=tina@gmail.com&password=tinaa123',
      params: {  },
      headers: {}
      assert_equal "Invalid credentials", json_response["errors"]
      assert_response :unprocessable_entity
    end
    
   test 'should not create user if initial balance for saving less than 100' do
    post '/users.json',
     params: user_details.except(:balance).merge(balance: 10),
    headers: {}
    assert_equal "Balance must be greater than 100 for saving account", json_response["errors"][1]
    assert_response :unprocessable_entity
  end

 test 'should not create user if initial balance for current less than 500' do
    post '/users.json',
    params: user_details.except(:acc_type, :balance).merge(acc_type: 'current', balance: 100),
    headers: {}
    assert_equal "Balance must be greater than 500 for current account", json_response["errors"][1]
    assert_response :unprocessable_entity
  end

  test 'should not create user if account type name invalid' do
    post '/users.json',
    params: user_details.except(:acc_type).merge(acc_type: "loans"),
    headers: {}
    assert_equal 'Acc type is invalid', json_response["errors"][1]
    assert_response :unprocessable_entity
  end

  # test 'retrieve all users' do
  #   get '/users.json',
  #   params: {},
  #   headers: { Authorization: "Bearer #{nuser_toke}"}
  #   assert_equal "Tina Patil" , json_response[0]["full_name"]
  #   assert_equal "667656565123", json_response[0]["aadhar_no"]
  #   assert_equal "SXDPS2246Q", json_response[0]["pan_no"]
  #   assert_equal 9034376311, json_response[0]["mobile_no"]
  #   assert_response :ok
  # end

  test 'retrieve user with user id' do
    get '/users/8ff963df-b879-5b14-aff5-186c2e22cb35.json', 
    params: {}, 
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal "Tina Patil", json_response["full_name"]
    assert_equal "667656565123", json_response["aadhar_no"]
    assert_equal "SXDPS2246Q", json_response["pan_no"]
    assert_equal 'tina@gmail.com', json_response["email_id"]
    assert_equal 9034376311, json_response["mobile_no"]
    assert_response :ok
  end

  test 'Checks that you always get your own details, even if you try requesting someone elses ID' do
    get '/users/7ef963df-b879-5b14-aff5-186c2e22cb35.json', 
    params: {}, 
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal "Tina Patil", json_response["full_name"]
    assert_equal "667656565123", json_response["aadhar_no"]
    assert_equal "SXDPS2246Q", json_response["pan_no"]
    assert_equal 'tina@gmail.com', json_response["email_id"]
    assert_equal 9034376311, json_response["mobile_no"]
  end

  test 'should update mobile no of logged in user' do
    patch '/users/e25ac701-1b69-4d84-b596-956ba3951f18.json',
    params: {
      mobile_no: 7878786767
    },
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'Tina Patil', json_response["full_name"]
    assert_equal '667656565123', json_response["aadhar_no"]
    assert_equal 'SXDPS2246Q', json_response["pan_no"]
    assert_equal 'tina@gmail.com', json_response["email_id"]
    assert_equal 7878786767, json_response["mobile_no"]
    assert_response :ok
  end

  test 'Updates your own details, even if you try requesting via someone elses ID' do
    patch '/users/8ff963df-b879-5b14-aff5-186c2e22ee35.json',
    params: {
     email_id: "tinuu@gmail.com"
    },
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'Tina Patil', json_response["full_name"]
    assert_equal '667656565123', json_response["aadhar_no"]
    assert_equal 'SXDPS2246Q', json_response["pan_no"]
    assert_equal 'tinuu@gmail.com', json_response["email_id"]
    assert_equal 9034376311, json_response["mobile_no"]
    assert_response :ok
  end

  test 'User verification of registered user with valid details' do
    post '/users/aadhar-verification.json',
    params: {
      aadhar_no: "667656565123",
      mobile_no: 9034376311
    },
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'Verified', json_response['message']
    assert_response :ok
  end

  test 'User verification of registered user with valid aadhar and invalid mobile no' do
    post '/users/aadhar-verification.json',
    params: {
      aadhar_no: "667656565123",
      mobile_no: 9034376322
    },
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'Invalid mobile number', json_response['errors']
    assert_response :unprocessable_entity
  end

  test 'User verification of registered user with invalid details' do
    post '/users/aadhar-verification.json',
    params: {
      aadhar_no: "447656565123",
      mobile_no: 9034376322
    },
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'Invalid aadhar number', json_response['errors']
    assert_response :unprocessable_entity
  end

#---------------------Account-------------------------------------------------------------

  test 'show all accounts for logged in user' do
    get "/accounts.json",
    params: {},
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 2, json_response["Total_Accounts"]
    assert_equal "Tina Patil", json_response["accounts_details"].first["full_name"]
    assert_equal 45674567, json_response["accounts_details"].first["account_number"]
    assert_equal "saving", json_response["accounts_details"].first["account_type"]
    assert_equal 3000, json_response["accounts_details"].first["balance"]
    assert_equal "ABHYUDAYA COOPERATIVE BANK LIMITED", json_response["accounts_details"].first["bank_name"]
    assert_equal "ABHY0065017", json_response["accounts_details"].first["ifsc_code"]
    assert_equal 1, json_response["accounts_details"].first["activity_logs"].first["id"]
    assert_equal "created", json_response["accounts_details"].first["activity_logs"].first["action"]
    assert_equal "2026-06-02T05:18:05.643Z", json_response["accounts_details"].first["activity_logs"].first["created_at"]

    assert_equal "Tina Patil", json_response["accounts_details"].second["full_name"]
    assert_equal 45664576, json_response["accounts_details"].second["account_number"]
    assert_equal "current", json_response["accounts_details"].second["account_type"]
    assert_equal 1500, json_response["accounts_details"].second["balance"]
    assert_equal "ABHYUDAYA COOPERATIVE BANK LIMITED", json_response["accounts_details"].second["bank_name"]
    assert_equal "ABHY0065101", json_response["accounts_details"].second["ifsc_code"]
    assert_equal 2, json_response["accounts_details"].second["activity_logs"].first["id"]
    assert_equal "created", json_response["accounts_details"].second["activity_logs"].first["action"]
    assert_equal "2026-06-02T06:17:05.643Z", json_response["accounts_details"].second["activity_logs"].first["created_at"]

    assert_response :ok
  end


  test 'delete logged in user account using account id' do
    delete '/accounts/979c4acf-1c38-48d1-b158-4feb6ed353aa.json', 
    params: {},
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'Account deleted for id 979c4acf-1c38-48d1-b158-4feb6ed353aa', json_response["message"]
  end
    
  test 'should not delete users account if not present' do
    delete '/accounts/888c4acf-1c38-48d1-b158-4feb6ed353bb.json', 
    params: {},
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'Account doesnt exists', json_response["errors"]
    assert_response :unprocessable_entity
  end

  test 'should not same create account if already that type of account exist for user' do
    post '/accounts.json',
    params: {
    acc_type: "current",
    balance: "3000", 
    ifsc: "ABHY0065101"
    },
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal "Acc type with this user already exists ", json_response["errors"][0]
    assert_response :unprocessable_entity
  end


  test 'create new account for existing user' do
    post '/accounts.json',
    params: {
    acc_type: "saving",
    balance: "3000", 
    ifsc: "ABHY0065101"
    },
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal "Account created for existing user", json_response["message"]
    assert_response :ok
  end
  
#---------------------------------- Transaction-------------------------------------------------------------------------

  test 'valid transaction between sender and receiver' do
    post '/transactions.json', 
    params: {
      "source_accno": "45674567",
      "amount": 100,
      "receiver_accno": "45664576"
    }, 
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'Transaction successful', json_response["message"]
    assert_response :ok
    
  end

  test 'should not create transaction if source account doesnt exist' do
    post '/transactions.json', 
    params: {
      "source_accno": "34345678",
      "amount": 100,
      "receiver_accno": "45664576"
    }, 
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'Source account does not exist!', json_response["errors"]
    assert_response :unprocessable_entity
  end

  test 'should not create transaction if destination account doesnt exist' do
    post '/transactions.json', 
    params: {
      "source_accno": "45674567",
      "amount": 100,
      "receiver_accno": "12364576"
    }, 
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'Destination account does not exist!', json_response["errors"]
    assert_response :unprocessable_entity
  end

  test 'should not perform transaction if source balance insufficient' do
    post '/transactions.json', 
    params: {
    "source_accno": "45674567",
    "amount": 1000000,
    "receiver_accno": "45664576"
    }, 
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'Not enough balance', json_response["errors"]
    assert_response :unprocessable_entity
  end

  test 'should not perform transaction if source and destination accounts are same' do
    post '/transactions.json', 
    params: {
    "source_accno": "45674567",
    "amount": 200,
    "receiver_accno": "45674567"
    }, 
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 'cannot transfer to same account', json_response["errors"]
    assert_response :unprocessable_entity
  end

  test 'view all the transactions of LoggedIn user' do
    get '/transactions.json',
    params: {},
    headers: {Authorization: "Bearer #{user_token}"}

    assert_equal 4, json_response["Total_Transactions"]

    assert_equal "f808b133-5769-466b-b406-6fe6bf88674d", json_response["Transactions"].first["id"]
    assert_equal 45664576, json_response["Transactions"].first["source_account_number"]
    assert_equal 100, json_response["Transactions"].first["amount"]
    assert_equal "debit", json_response["Transactions"].first["operation"]
    assert_equal 87974567, json_response["Transactions"].first["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].first["activity_logs"].first["action"]
    assert_equal "2026-06-01T04:17:05.643Z", json_response["Transactions"].first["activity_logs"].first["created_at"]
    
    assert_equal "74c55d7a-c09e-41c8-a03e-a2dadbc75d46", json_response["Transactions"].second["id"]
    assert_equal 87974567, json_response["Transactions"].second["source_account_number"]
    assert_equal 150, json_response["Transactions"].second["amount"]
    assert_equal "credit", json_response["Transactions"].second["operation"]
    assert_equal 45674567, json_response["Transactions"].second["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].second["activity_logs"].first["action"]
    assert_equal "2026-06-02T03:07:05.643Z", json_response["Transactions"].second["activity_logs"].first["created_at"]

    assert_equal "81f9074d-6950-45bd-8427-5bd4b017f0dd", json_response["Transactions"].third["id"]
    assert_equal 87974567, json_response["Transactions"].third["source_account_number"]
    assert_equal 200, json_response["Transactions"].third["amount"]
    assert_equal "credit", json_response["Transactions"].third["operation"]
    assert_equal 45664576, json_response["Transactions"].third["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].third["activity_logs"].first["action"]
    assert_equal "2026-06-02T02:17:05.643Z", json_response["Transactions"].third["activity_logs"].first["created_at"]

    assert_equal "b2f8e592-6950-45b7-829e-eba0ed1eb2a7", json_response["Transactions"].fourth["id"]
    assert_equal 45674567, json_response["Transactions"].fourth["source_account_number"]
    assert_equal 250, json_response["Transactions"].fourth["amount"]
    assert_equal "credit", json_response["Transactions"].fourth["operation"]
    assert_equal 45664576, json_response["Transactions"].fourth["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].fourth["activity_logs"].first["action"]
    assert_equal "2026-06-01T05:17:05.643Z", json_response["Transactions"].fourth["activity_logs"].first["created_at"]

    assert_response :ok
  end

  test 'view transactions for only credit operation' do
    get '/transactions.json',
    params: {operation: 'CREDIT'},
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 3, json_response["Total_Transactions"]

    assert_equal "74c55d7a-c09e-41c8-a03e-a2dadbc75d46", json_response["Transactions"].first["id"]
    assert_equal 87974567, json_response["Transactions"].first["source_account_number"]
    assert_equal 150, json_response["Transactions"].first["amount"]
    assert_equal "credit", json_response["Transactions"].first["operation"]
    assert_equal 45674567, json_response["Transactions"].first["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].first["activity_logs"].first["action"]
    assert_equal "2026-06-02T03:07:05.643Z", json_response["Transactions"].first["activity_logs"].first["created_at"]

    assert_equal "81f9074d-6950-45bd-8427-5bd4b017f0dd", json_response["Transactions"].second["id"]
    assert_equal 87974567, json_response["Transactions"].second["source_account_number"]
    assert_equal 200, json_response["Transactions"].second["amount"]
    assert_equal "credit", json_response["Transactions"].second["operation"]
    assert_equal 45664576, json_response["Transactions"].second["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].second["activity_logs"].first["action"]
    assert_equal "2026-06-02T02:17:05.643Z", json_response["Transactions"].second["activity_logs"].first["created_at"]

    assert_equal "b2f8e592-6950-45b7-829e-eba0ed1eb2a7", json_response["Transactions"].third["id"]
    assert_equal 45674567, json_response["Transactions"].third["source_account_number"]
    assert_equal 250, json_response["Transactions"].third["amount"]
    assert_equal "credit", json_response["Transactions"].third["operation"]
    assert_equal 45664576, json_response["Transactions"].third["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].third["activity_logs"].first["action"]
    assert_equal "2026-06-01T05:17:05.643Z", json_response["Transactions"].third["activity_logs"].first["created_at"]
    assert_response :ok
  end

  test 'view transactions for only debit operation' do
    get '/transactions.json',
    params: {operation: 'DEBIT'},
    headers: {Authorization: "Bearer #{user_token}"}

    assert_equal 2, json_response["Total_Transactions"]

    assert_equal "f808b133-5769-466b-b406-6fe6bf88674d", json_response["Transactions"].first["id"]
    assert_equal 45664576, json_response["Transactions"].first["source_account_number"]
    assert_equal 100, json_response["Transactions"].first["amount"]
    assert_equal "debit", json_response["Transactions"].first["operation"]
    assert_equal 87974567, json_response["Transactions"].first["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].first["activity_logs"].first["action"]
    assert_equal "2026-06-01T04:17:05.643Z", json_response["Transactions"].first["activity_logs"].first["created_at"]

    assert_equal "b2f8e592-6950-45b7-829e-eba0ed1eb2a7", json_response["Transactions"].second["id"]
    assert_equal 45674567, json_response["Transactions"].second["source_account_number"]
    assert_equal 250, json_response["Transactions"].second["amount"]
    assert_equal "credit", json_response["Transactions"].second["operation"]
    assert_equal 45664576, json_response["Transactions"].second["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].second["activity_logs"].first["action"]
    assert_equal "2026-06-01T05:17:05.643Z", json_response["Transactions"].second["activity_logs"].first["created_at"]

    assert_response :ok
  end
  
  test 'Should not view transactions if invalid operation' do
    get '/transactions.json',
    params: {operation: 'abcd'},
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 0, json_response['Total_Transactions']
    assert_response :ok
  end

  test 'Should view transactions by filtering minimum amount' do
    get '/transactions.json',
    params: {minimum: 150},
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 3, json_response['Total_Transactions']
    
    assert_equal "74c55d7a-c09e-41c8-a03e-a2dadbc75d46", json_response["Transactions"].first["id"]
    assert_equal 87974567, json_response["Transactions"].first["source_account_number"]
    assert_equal 150, json_response["Transactions"].first["amount"]
    assert_equal "credit", json_response["Transactions"].first["operation"]
    assert_equal 45674567, json_response["Transactions"].first["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].first["activity_logs"].first["action"]
    assert_equal "2026-06-02T03:07:05.643Z", json_response["Transactions"].first["activity_logs"].first["created_at"]

    assert_equal "81f9074d-6950-45bd-8427-5bd4b017f0dd", json_response["Transactions"].second["id"]
    assert_equal 87974567, json_response["Transactions"].second["source_account_number"]
    assert_equal 200, json_response["Transactions"].second["amount"]
    assert_equal "credit", json_response["Transactions"].second["operation"]
    assert_equal 45664576, json_response["Transactions"].second["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].second["activity_logs"].first["action"]
    assert_equal "2026-06-02T02:17:05.643Z", json_response["Transactions"].second["activity_logs"].first["created_at"]

    assert_equal "b2f8e592-6950-45b7-829e-eba0ed1eb2a7", json_response["Transactions"].third["id"]
    assert_equal 45674567, json_response["Transactions"].third["source_account_number"]
    assert_equal 250, json_response["Transactions"].third["amount"]
    assert_equal "credit", json_response["Transactions"].third["operation"]
    assert_equal 45664576, json_response["Transactions"].third["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].third["activity_logs"].first["action"]
    assert_equal "2026-06-01T05:17:05.643Z", json_response["Transactions"].third["activity_logs"].first["created_at"]
    
    assert_response :ok
  
  end

    test 'Should view transactions by filtering maximum amount' do
    get '/transactions.json',
    params: {maximum: 150},
    headers: {Authorization: "Bearer #{user_token}"}
    assert_equal 2, json_response['Total_Transactions']
  
    assert_equal "f808b133-5769-466b-b406-6fe6bf88674d", json_response["Transactions"].first["id"]
    assert_equal 45664576, json_response["Transactions"].first["source_account_number"]
    assert_equal 100, json_response["Transactions"].first["amount"]
    assert_equal "debit", json_response["Transactions"].first["operation"]
    assert_equal 87974567, json_response["Transactions"].first["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].first["activity_logs"].first["action"]
    assert_equal "2026-06-01T04:17:05.643Z", json_response["Transactions"].first["activity_logs"].first["created_at"]
    
    assert_equal "74c55d7a-c09e-41c8-a03e-a2dadbc75d46", json_response["Transactions"].second["id"]
    assert_equal 87974567, json_response["Transactions"].second["source_account_number"]
    assert_equal 150, json_response["Transactions"].second["amount"]
    assert_equal "credit", json_response["Transactions"].second["operation"]
    assert_equal 45674567, json_response["Transactions"].second["receiver_account_number"]
    assert_equal "created", json_response["Transactions"].second["activity_logs"].first["action"]
    assert_equal "2026-06-02T03:07:05.643Z", json_response["Transactions"].second["activity_logs"].first["created_at"]

    assert_response :ok
  end

  def user_details
    {"aadhar_no": "445566778899",
    "pan_no": "VBDPS2246Q",
    "mobile_no": 8934376222,
    "first_name": "Riya",                       
    "last_name": "pawar",
    "email_id": "riya@gmail.com",
    "password": "riya123",
    "password_confirmation": "riya123",
    "acc_type": "saving",
    "balance": "3000",
    "ifsc": "ABHY0065017"}

  end

end

