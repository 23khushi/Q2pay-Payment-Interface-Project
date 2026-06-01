class AuthorizeUser

  RULES = {
    "super_admin"=> :all, 
    "admin"=> {
      "users"=> [:index, :update, :show], 
      "payments"=> [:index], 
      "accounts"=> :all
    }, 
    "user"=>{
      "users"=> [:update, :show, :create],
      "payments"=> [:create, :index], 
      "accounts"=> :all
    }
  }


  def initialize(controller, action_name)
    @controller = controller
    @current_user = controller.current_user
    @role = @current_user&.role
    @action_name = action_name.to_sym
  end

  def allowed?
    return true if @role == 'super_admin'
    rules = RULES[@role]
    return false unless rules
    return true if rules == :all
    @controller_rules = rules[@controller.controller_name]
    return false unless @controller_rules

    @controller_rules == :all || @controller_rules.include?(@action_name)

  end
end