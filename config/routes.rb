Rails.application.routes.draw do
  scope "/auth" do
    post "register", to: "auth#register"
    post "login", to: "auth#login"
    get "validate", to: "auth#validate"
  end
end