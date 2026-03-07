require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get register" do
    get auth_register_url
    assert_response :success
  end

  test "should get login" do
    get auth_login_url
    assert_response :success
  end

  test "should get validate" do
    get auth_validate_url
    assert_response :success
  end
end
