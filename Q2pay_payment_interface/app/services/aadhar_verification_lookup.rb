class AadharVerificationLookup
  DATA = {
    "565677778987" => {
    pan_no: "RITPS3422Y",
    mobile_no: 7122112111,
    first_name: "Sakshi",
    last_name: "Pawar",
    email_id: "sakshi@gmail.com",
    password: "sakshi123",
    password_confirmation: "sakshi123",
    acc_type: "current",
    balance: "2000",
    ifsc: "ABHY0065015"
    },

    "567856703452" => {
    pan_no: "SABPS3422Y",
    mobile_no: 9855112111,
    first_name: "Khushi",
    last_name: "Solanki",
    email_id: "khushi@gmail.com",
    password: "khushi123",
    password_confirmation: "khushi123",
    acc_type: "saving",
    balance: "4000",
    ifsc: "AKJB0000003"
    },
    "958756703452" => {
    pan_no: "SINPS3422Y",
    mobile_no: 9823412120,
    first_name: "Anchit",
    last_name: "Mishra",
    email_id: "anchit@gmail.com",
    password: "anchit123",
    password_confirmation: "anchit123",
    acc_type: "saving",
    balance: "1500",
    ifsc: "ALLA0210140"
    }, 
    "967856703488" => {
    pan_no: "BROPS3423W",
    mobile_no: 8900412120,
    first_name: "Yogesh",
    last_name: "Sutar",
    email_id: "yogesh@gmail.com",
    password: "yogesh123",
    password_confirmation: "yogesh123",
    acc_type: "current",
    balance: "2500",
    ifsc: "ALLA0210226"
    },
    "990856703222" => {
    pan_no: "NITPS3424H",
    mobile_no: 9905412110,
    first_name: "Rishi",
    last_name: "Patel",
    email_id: "rishi@gmail.com",
    password: "rishi123",
    password_confirmation: "rishi123",
    acc_type: "saving",
    balance: "2000",
    ifsc: "BARB0BIRWAD"
    },
    "667656565123" => {
      pan_no: "SXDPS2246Q",
      mobile_no: 9034376311,
      first_name: "Tina",
      last_name: "Patil",
      email_id: "tina@gmail.com",
      password: "tina123",
      password_confirmation: "tina123",
      acc_type: "saving",
      balance: 3000,
      ifsc: "ABHY0065017" 
    }
  }
    def self.find_aadhar(aadhar_no)
      return DATA[aadhar_no]
    end
 
end