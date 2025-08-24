module AuthenticationHelpers
  def sign_in(user)
    post session_path, params: { email_address: user.email_address, password: user.password }
  end

  def sign_in_api(user)
    post session_path, params: { email_address: user.email_address, password: "password123" }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end
