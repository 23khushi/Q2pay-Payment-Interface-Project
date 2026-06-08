class UserLogin
  def self.login(email_id, password)
    user = User.find_by(email_id: email_id)
    if user&.authenticate(password)
      token = JsonWebToken.encode(id: user.id)
      { success: true, token: token }
    else
      { success: false, message: "Invalid credentials" }
    end
  end
end
