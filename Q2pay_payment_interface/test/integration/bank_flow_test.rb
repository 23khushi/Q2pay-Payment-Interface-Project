require "test_helper"

class BankFlowTest < ActionDispatch::IntegrationTest
  test 'should create user' do
    post '/users.json',
    params: {
    "aadhar_no": "887656565123",
    "pan_no": "VBDPS2246Q",
    "mobile_no": 8934376222,
    "first_name": "Riya",
    "last_name": "pawar",
    "pin": 1234,
    "acc_type": "saving",
    "balance": "3000",
    "bank_name": "icici",
    "ifsc_code": "ICIC0000123" 
    },
    headers: {}  
    resp = JSON.parse(response.body)
    assert_equal "Riya pawar", resp["full_name"]
    assert_equal "icici", resp["bank_name"]
    assert_equal "ICIC0000123", resp["ifsc_code"]
    assert_response :ok
  end

  test 'should not create user if aadhar is already present' do
    post '/users.json',
    params: {
    "aadhar_no": "667656565123",
    "pan_no": "VBDPS3336P",
    "mobile_no": 9904376222,
    "first_name": "siya",
    "last_name": "patel",
    "pin": 1234,
    "acc_type": "saving",
    "balance": "3000",
    "bank_name": "icici",
    "ifsc_code": "ICIC0000123" 
    },
    headers: {}  
    resp = JSON.parse(response.body)
    assert_equal "Validation failed: Aadhar no Already registered", resp["errors"]
    assert_response :ok
  end

  test 'should not create user if mobile no already present' do
    post '/users.json', 
    params: {
    "aadhar_no": "667656565456",
    "pan_no": "VBDPS3336P",
    "mobile_no": 9034376311,
    "first_name": "siya",
    "last_name": "patel",
    "pin": 1234,
    "acc_type": "saving",
    "balance": "3000",
    "bank_name": "icici",
    "ifsc_code": "ICIC0000123" 
    },
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal "Validation failed: Mobile no Already registered", resp["errors"]
    assert_response :ok
  end

  test 'should not create user if pan no already present' do
    post '/users.json',
    params: {
    "aadhar_no": "567656565456",
    "pan_no": "SXDPS2246Q",
    "mobile_no": 9134376211,
    "first_name": "siya",
    "last_name": "patel",
    "pin": 1234,
    "acc_type": "saving",
    "balance": "3000",
    "bank_name": "icici",
    "ifsc_code": "ICIC0000123" 
    },
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal "Validation failed: Pan no Already registered", resp["errors"]
    assert_response :ok
  end

  test 'should not create user if aadhar and mobile no already exists' do
    post '/users.json',
     params: {
    "aadhar_no": "667656565123",
    "pan_no": "SDDPS2246Q",
    "mobile_no": 9034376311,
    "first_name": "siya",
    "last_name": "patel",
    "pin": 1234,
    "acc_type": "saving",
    "balance": "3000",
    "bank_name": "icici",
    "ifsc_code": "ICIC0000123" 
    },
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal "Validation failed: Aadhar no Already registered, Mobile no Already registered", resp["errors"]
    assert_response :ok

  end

    test 'should not create user if aadhar and pan no already exists' do
      post '/users.json',
       params: {
      "aadhar_no": "667656565123",
      "pan_no": "SXDPS2246Q",
      "mobile_no": 9134376311,
      "first_name": "siya",
      "last_name": "patel",
      "pin": 1234,
      "acc_type": "saving",
      "balance": "3000",
      "bank_name": "icici",
      "ifsc_code": "ICIC0000123" 
      },
      headers: {}
      resp = JSON.parse(response.body)
      assert_equal "Validation failed: Aadhar no Already registered, Pan no Already registered", resp["errors"]
      assert_response :ok

    end


    test 'should not create user if mobile and pan no already exists' do
      post '/users.json',
       params: {
      "aadhar_no": "657656565123",
      "pan_no": "SXDPS2246Q",
      "mobile_no": 9034376311,
      "first_name": "siya",
      "last_name": "patel",
      "pin": 1234,
      "acc_type": "saving",
      "balance": "3000",
      "bank_name": "icici",
      "ifsc_code": "ICIC0000123" 
      },
      headers: {}
      resp = JSON.parse(response.body)
      assert_equal "Validation failed: Pan no Already registered, Mobile no Already registered", resp["errors"]
      assert_response :ok
    end

    test 'should not create user if mobile, pan and aadhar no already exists' do
    post '/users.json',
     params: {
    "aadhar_no": "667656565123",
    "pan_no": "SXDPS2246Q",
    "mobile_no": 9034376311,
    "first_name": "siya",
    "last_name": "patel",
    "pin": 1234,
    "acc_type": "saving",
    "balance": "3000",
    "bank_name": "icici",
    "ifsc_code": "ICIC0000123" 
    },
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal "Validation failed: Aadhar no Already registered, Pan no Already registered, Mobile no Already registered", resp["errors"]
    assert_response :ok
  end

  test 'should not create user if mobile, pan, aadhar, acctype already exists' do
    post '/users.json',
     params: {
    "aadhar_no": "667656565123",
    "pan_no": "SXDPS2246Q",
    "mobile_no": 9034376311,
    "first_name": "Tina",
    "last_name": "Patil",
    "pin": 1234,
    "acc_type": "saving",
    "balance": "3000",
    "bank_name": "icici",
    "ifsc_code": "ICIC0000123" 
    },
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal "Validation failed: Acc type with this user already exists ", resp["errors"]
    assert_response :ok
  end

   test 'should not create user if initial balance for saving less than 100' do
    post '/users.json',
     params: {
    "aadhar_no": "567656565123",
    "pan_no": "CDDPS2246Q",
    "mobile_no": 9124376311,
    "first_name": "siya",
    "last_name": "patel",
    "pin": 1234,
    "acc_type": "saving",
    "balance": "50",
    "bank_name": "icici",
    "ifsc_code": "ICIC0000123" 
    },
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal "Validation failed: Balance must be greater than 100 for saving account", resp["errors"]
    assert_response :ok
  end

   test 'should not create user if initial balance for current less than 500' do
    post '/users.json',
     params: {
    "aadhar_no": "567656565123",
    "pan_no": "CDDPS2246Q",
    "mobile_no": 9124376311,
    "first_name": "siya",
    "last_name": "patel",
    "pin": 1234,
    "acc_type": "current",
    "balance": "450",
    "bank_name": "icici",
    "ifsc_code": "ICIC0000123" 
    },
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal "Validation failed: Balance must be greater than 500 for current account", resp["errors"]
    assert_response :ok
  end

  test 'should not create user if bank name invalid' do
    post '/users.json',
    params: {
    "aadhar_no": "567656565123",
    "pan_no": "CDDPS2246Q",
    "mobile_no": 9124376311,
    "first_name": "siya",
    "last_name": "patel",
    "pin": 1234,
    "acc_type": "current",
    "balance": "450",
    "bank_name": "kotak",
    "ifsc_code": "KOTA0000123" 
    },
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal 'Validation failed: Ifsc code is invalid for bank kotak, Bank name is not included in the list', resp["errors"]
    assert_response :ok
  end

  test 'should not create user if bank name and ifsc mismatch' do 
    post '/users.json',
    params: {
    "aadhar_no": "567656565123",
    "pan_no": "CDDPS2246Q",
    "mobile_no": 9124376311,
    "first_name": "siya",
    "last_name": "patel",
    "pin": 1234,
    "acc_type": "current",
    "balance": "1000",
    "bank_name": "hdfc",
    "ifsc_code": "ICIC0000123" 
    },
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal 'Validation failed: Ifsc code is invalid for bank hdfc', resp["errors"]
    assert_response :ok
  end

  test 'retrieve all users' do
    get '/users.json',
    params: {},
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal "Tina Patil" , resp[0]["full_name"]
    assert_equal "667656565123", resp[0]["aadhar_no"]
    assert_equal 9034376311, resp[0]["mobile_no"]
    assert_response :ok
  end

  test 'retrive user with specific id' do
    get '/users/8ff963df-b879-5b14-aff5-186c2e22cb35.json', 
    params: {}, 
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal "Rishi Patel", resp["full_name"]
    assert_equal "557656565123", resp["aadhar_no"]
    assert_equal 8934376311, resp["mobile_no"]
    assert_response :ok
  end

  test 'should not retrieve user with specific id if not present' do
    get '/users/7ef963df-b879-5b14-aff5-186c2e22cb35.json', 
    params: {}, 
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal 'User not found!', resp["errors"]
    assert_response :ok
  end

  test 'should update the users mobile no if exists' do
    patch '/users/8ff963df-b879-5b14-aff5-186c2e22cb35.json',
    params: {
      mobile_no: 7878786767
    },
    headers: {}
    resp =  JSON.parse(response.body)
    assert_equal 'Rishi Patel', resp["full_name"]
    assert_equal '557656565123', resp["aadhar_no"]
    assert_equal 'ECDPS2246Q', resp["pan_no"]
    assert_equal 7878786767, resp["mobile_no"]
    assert_equal 2222, resp["pin"]
    assert_response :ok
  end

  test 'should update the users name if exists' do
    patch '/users/8ff963df-b879-5b14-aff5-186c2e22cb35.json',
    params: {
      "first_name": "Rishi",
      "last_name": "Popat"
    },
    headers: {}
    resp =  JSON.parse(response.body)
    assert_equal 'Rishi Popat', resp["full_name"]
    assert_equal '557656565123', resp["aadhar_no"]
    assert_equal 'ECDPS2246Q', resp["pan_no"]
    assert_equal 8934376311, resp["mobile_no"]
    assert_equal 2222, resp["pin"]
    assert_response :ok
  end

  test 'should not update user if does not exists' do
    patch '/users/7ff963df-b879-5b14-aff5-186c2e22cb35.json',
     params: {
      "first_name": "Rishi",
      "last_name": "Kapoor"
    },
    headers: {}
    resp =  JSON.parse(response.body)
    assert_equal 'User not found', resp["errors"]
    assert_response :ok
  end


  test 'show users account using specific aadhar no' do
    get "/accounts.json?aadhar_no=667656565123",
    params: {},
    headers: {}
    resp = JSON.parse(response.body)
    pp resp
    # # pp resp.class
    # # pp resp[0]["name"]
    # pp resp[0]["accounts_details"][0]["account_number"]
    # pp resp[0]["account_details"]
    assert_equal 'Tina Patil', resp[0]["name"]
    assert_equal 45674567, resp[0]["accounts_details"][0]["account_number"]
    assert_equal 'saving', resp[0]["accounts_details"][0]["account_type"]
    assert_equal 3000, resp[0]["accounts_details"][0]["balance"]
    assert_equal 'ICICI', resp[0]["accounts_details"][0]["bank_name"]
    assert_equal 'ICIC0000123', resp[0]["accounts_details"][0]["ifsc_code"]
     assert_equal 45664576, resp[0]["accounts_details"][1]["account_number"]
    assert_equal 'current', resp[0]["accounts_details"][1]["account_type"]
    assert_equal 1500, resp[0]["accounts_details"][1]["balance"]
    assert_equal 'ICICI', resp[0]["accounts_details"][1]["bank_name"]
    assert_equal 'ICIC0000123', resp[0]["accounts_details"][1]["ifsc_code"]

    assert_response :ok
  end


  test 'show users account using specific pan no' do
    get "/accounts.json?pan_no=SXDPS2246Q",
    params: {},
    headers: {}
    resp = JSON.parse(response.body)
    pp resp
    assert_equal 'Tina Patil', resp[0]["name"]
    assert_equal 45674567, resp[0]["accounts_details"][0]["account_number"]
    assert_equal 'saving', resp[0]["accounts_details"][0]["account_type"]
    assert_equal 3000, resp[0]["accounts_details"][0]["balance"]
    assert_equal 'ICICI', resp[0]["accounts_details"][0]["bank_name"]
    assert_equal 'ICIC0000123', resp[0]["accounts_details"][0]["ifsc_code"]
    assert_response :ok
  end

  test 'show users account using specific mobile no' do
    get "/accounts.json?mobile_no=9034376311",
    params: {},
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal 'Tina Patil', resp[0]["name"]
    assert_equal 45674567, resp[0]["accounts_details"][0]["account_number"]
    assert_equal 'saving', resp[0]["accounts_details"][0]["account_type"]
    assert_equal 3000, resp[0]["accounts_details"][0]["balance"]
    assert_equal 'ICICI', resp[0]["accounts_details"][0]["bank_name"]
    assert_equal 'ICIC0000123', resp[0]["accounts_details"][0]["ifsc_code"]
    assert_response :ok
  end

  test 'delete user account using id' do
    delete '/accounts/3.json', 
    params: {},
    headers: {}
    resp =  JSON.parse(response.body)
    assert_equal 'Account deleted for id 3', resp ["message"]
  end
    
  test 'should not delete users account if not present' do
    delete '/accounts/5.json', 
    params: {},
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal 'Account doesnt exists', resp["errors"]
  end

  test 'valid transaction between sender and receiver' do
    post '/accounts/transaction.json', 
    params: {
      "source_accno": "87974567",
      "amount": 100,
      "receiver_accno": "45664576"
    }, 
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal 'Transaction successfull', resp["message"]
    assert_response :ok
    
  end

  test 'should not create transaction if source account doesnt exist' do
      post '/accounts/transaction.json', 
       params: {
      "source_accno": "82974567",
      "amount": 100,
      "receiver_accno": "45664576"
    }, 
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal 'Source account doesnt exist!', resp["errors"]
    assert_response :ok
  end

  test 'should not create transaction if destination account doesnt exist' do
    post '/accounts/transaction.json', 
     params: {
    "source_accno": "87974567",
    "amount": 100,
    "receiver_accno": "41664576"
    }, 
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal 'Destination account does not exist!', resp["errors"].first
    assert_response :ok
  end

  test 'should not perform transaction if source balance insufficient' do
    post '/accounts/transaction.json', 
    params: {
    "source_accno": "87974567",
    "amount": 1000000,
    "receiver_accno": "45664576"
    }, 
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal 'Not enough balance', resp["errors"].first
    assert_response :ok
  end

  test 'should not perform transaction if source and destination accounts are same' do
    post '/accounts/transaction.json', 
    params: {
    "source_accno": "87974567",
    "amount": 200,
    "receiver_accno": "87974567"
    }, 
    headers: {}
    resp = JSON.parse(response.body)
    assert_equal 'cannot transfer to same account', resp["errors"].first
    assert_response :ok
  end
  
end

