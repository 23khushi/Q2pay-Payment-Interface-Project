require "test_helper"

class BankFlowTest < ActionDispatch::IntegrationTest

  test 'should create user' do
    post '/users.json',
    params: user_details,
    headers: { }  
    resp = json_response
    assert_equal "Riya pawar", resp["full_name"]
    assert_equal "ABHYUDAYA COOPERATIVE BANK LIMITED", resp["bank_name"]
    assert_equal "MOBILE BANK", resp["branch_name"]
    assert_equal "ABHY0065017", resp["ifsc_code"]
    assert_response :created
  end

  test 'should not create user if aadhar is already present' do
    post '/users.json',
    params: user_details.except(:aadhar_no).merge(aadhar_no: "667656565123"),
    headers: {}  
    resp = json_response
    assert_equal "Aadhar no Already registered", resp["errors"][0]
    assert_response :unprocessable_entity
  end

  test 'should not create user if mobile no already present' do
    post '/users.json', 
    params: user_details.except(:mobile_no).merge(mobile_no: 8934376311),
    headers: {}
    resp = json_response
    assert_equal "Mobile no Already registered", resp["errors"][0]
    assert_response :unprocessable_entity
  end

  test 'should not create user if pan no already present' do
    post '/users.json',
    params: user_details.except(:pan_no).merge(pan_no: "ECDPS2246Q"),
    headers: {}
    resp = json_response
    assert_equal "Pan no Already registered", resp["errors"][0]
    assert_response :unprocessable_entity
  end

  test 'should not create user with existing email_id' do
    post '/users.json',
    params: user_details.except(:email_id).merge(email_id: "tina@gmail.com"),
    headers: {}
    resp = json_response
    assert_equal "Email Already registered", resp["errors"][0]
    assert_response :unprocessable_entity
   end

    test 'should not create user if password and password confirmation doesnt match' do
      post '/users.json',
       params: user_details.except(:password_confirmation).merge(password_confirmation: "tinaa1234"),
      headers: {}
      resp = json_response
      assert_equal "Password confirmation doesn't match Password", resp["errors"][0]
      assert_response :unprocessable_entity

    end


    test 'Registered user should be able to login' do
      post '/users/login?email_id=tina@gmail.com&password=tina123',
       params: {  },
      headers: {}
      resp = json_response
      assert_equal "Login Successful", resp["message"]
      assert_response :ok
    end

    test 'User should not be able to login if credentials invalid' do
      post '/users/login?email_id=tina@gmail.com&password=tinaa123',
      params: {  },
      headers: {}
      resp = json_response
      assert_equal "Invalid credentials", resp["errors"]
      assert_response :unprocessable_entity
    end
    
   test 'should not create user if initial balance for saving less than 100' do
    post '/users.json',
     params: user_details.except(:balance).merge(balance: 10),
    headers: {}
    resp = json_response
    assert_equal "Balance must be greater than 100 for saving account", resp["errors"][1]
    assert_response :unprocessable_entity
  end

 test 'should not create user if initial balance for current less than 500' do
    post '/users.json',
    params: user_details.except(:acc_type, :balance).merge(acc_type: 'current', balance: 100),
    headers: {}
    resp = json_response
    assert_equal "Balance must be greater than 500 for current account", resp["errors"][1]
    assert_response :unprocessable_entity
  end

  test 'should not create user if account type name invalid' do
    post '/users.json',
    params: user_details.except(:acc_type).merge(acc_type: "loans"),
    headers: {}
    resp = json_response
    assert_equal 'Acc type is invalid', resp["errors"][1]
    assert_response :unprocessable_entity
  end

  test 'retrieve all users' do
    get '/users.json',
    params: {},
    headers: { Authorization: "Bearer #{user_token}"}
    resp = json_response
    assert_equal "Tina Patil" , resp[0]["full_name"]
    assert_equal "667656565123", resp[0]["aadhar_no"]
    assert_equal "SXDPS2246Q", resp[0]["pan_no"]
    assert_equal 9034376311, resp[0]["mobile_no"]
    assert_response :ok
  end

  test 'retrieve user with specific id' do
    get '/users/8ff963df-b879-5b14-aff5-186c2e22cb35.json', 
    params: {}, 
    headers: {Authorization: "Bearer #{user_token}"}
    resp = json_response
    assert_equal "Rishi Patel", resp["full_name"]
    assert_equal "557656565123", resp["aadhar_no"]
    assert_equal "ECDPS2246Q", resp["pan_no"]
    assert_equal 8934376311, resp["mobile_no"]
    assert_response :ok
  end

  test 'should not retrieve user with specific id if not present' do
    get '/users/7ef963df-b879-5b14-aff5-186c2e22cb35.json', 
    params: {}, 
    headers: {Authorization: "Bearer #{user_token}"}
    resp = json_response
    assert_equal 'User not found', resp["errors"]
    assert_response :not_found
  end

  test 'should update mobile no of logged in user' do
    patch '/users/e25ac701-1b69-4d84-b596-956ba3951f18.json',
    params: {
      mobile_no: 7878786767
    },
    headers: {Authorization: "Bearer #{user_token}"}
    resp = json_response
    assert_equal 'Tina Patil', resp["full_name"]
    assert_equal '667656565123', resp["aadhar_no"]
    assert_equal 'SXDPS2246Q', resp["pan_no"]
    assert_equal 7878786767, resp["mobile_no"]
    assert_response :ok
  end

  test 'should not update the mail id if user not logged in or invalid user' do
    patch '/users/8ff963df-b879-5b14-aff5-186c2e22ee35.json',
    params: {
     email_id: "tinuu@gmail.com"
    },
    headers: {Authorization: "Bearer #{user_token}"}
    resp = json_response
    assert_equal 'User not found', resp['errors']
    assert_response :not_found
  end

  test 'User verification of registered user with valid details' do
    post '/users/aadhar-verification.json',
    params: {
      aadhar_no: "667656565123",
      mobile_no: 9034376311
    },
    headers: {Authorization: "Bearer #{user_token}"}
    resp = json_response
    assert_equal 'Verified', resp['message']
    assert_response :ok
  end

  test 'User verification of registered user with valid aadhar and invalid mobile no' do
    post '/users/aadhar-verification.json',
    params: {
      aadhar_no: "667656565123",
      mobile_no: 9034376322
    },
    headers: {Authorization: "Bearer #{user_token}"}
    resp = json_response
    assert_equal 'Invalid mobile number', resp['errors']
    assert_response :unprocessable_entity
  end

  test 'User verification of registered user with invalid details' do
    post '/users/aadhar-verification.json',
    params: {
      aadhar_no: "447656565123",
      mobile_no: 9034376322
    },
    headers: {Authorization: "Bearer #{user_token}"}
    resp = json_response
    assert_equal 'Invalid aadhar number', resp['errors']
    assert_response :unprocessable_entity
  end

#---------------------Account-------------------------------------------------------------

  test 'show all accounts for logged in user' do
    get "/accounts.json",
    params: {},
    headers: {Authorization: "Bearer #{user_token}"}
    resp = json_response
    assert_equal 'Tina Patil', resp["name"]
    assert_equal 45674567, resp["accounts_details"][0]["account_number"]
    assert_equal 'saving', resp["accounts_details"][0]["account_type"]
    assert_equal 3000, resp["accounts_details"][0]["balance"]
    assert_equal 'ABHYUDAYA COOPERATIVE BANK LIMITED', resp["accounts_details"][0]["bank_name"]
    assert_equal 'ABHY0065017', resp["accounts_details"][0]["ifsc_code"]
     assert_equal 45664576, resp["accounts_details"][1]["account_number"]
    assert_equal 'current', resp["accounts_details"][1]["account_type"]
    assert_equal 1500, resp["accounts_details"][1]["balance"]
    assert_equal 'ABHYUDAYA COOPERATIVE BANK LIMITED', resp["accounts_details"][1]["bank_name"]
    assert_equal 'ABHY0065101', resp["accounts_details"][1]["ifsc_code"]

    assert_response :ok
  end


  test 'delete logged in user account using account id' do
    delete '/accounts/3.json', 
    params: {},
    headers: {Authorization: "Bearer #{user_token}"}
    resp = json_response
    assert_equal 'Account deleted for id 3', resp ["message"]
  end
    
  test 'should not delete users account if not present' do
    delete '/accounts/5.json', 
    params: {},
    headers: {Authorization: "Bearer #{user_token}"}
    resp = json_response
    assert_equal 'Account doesnt exists', resp["errors"]
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
    resp = json_response
    assert_equal "Acc type with this user already exists ", resp["errors"][0]
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
    resp = json_response
    assert_equal "Account created for existing user", resp["message"]
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
    resp = json_response
    assert_equal 'Transaction successful', resp["message"]
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
    resp = json_response
    assert_equal 'Source account does not exist!', resp["errors"].first
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
    resp = json_response
    assert_equal 'Destination account does not exist!', resp["errors"].first
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
    resp = json_response
    assert_equal 'Not enough balance', resp["errors"].first
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
    resp = json_response
    assert_equal 'cannot transfer to same account', resp["errors"].first
    assert_response :unprocessable_entity
  end

  # test 'view all the transactions of LoggedIn user' do
  #   get '/transactions.json',
  #   params: {},
  #   headers: {Authorization: "Bearer #{user_token}"}
  #   resp = json_response
  #   pp resp
  #   pp resp[0]
  #   assert_equal '{"source_account_number" => 45674567, "amount" => 100, "receiver_account_number" => 45664576}', resp[0]
  #   assert_response :ok
  # end
  
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

