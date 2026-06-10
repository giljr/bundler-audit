require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "this test should fail" do
  #   assert_equal 1, 2, "Forcing a failure: 1 is not equal to 2"
  # end

  # Load fixtures
  fixtures :users

  test 'email deve estar presente' do
    # Use the fixture user
    user = users(:invalid_user)
    # user = User.new(email: nil, password: "password")
    refute user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test 'user não loga sem password' do
    # Use the fixture user
    user = users(:no_password_user)
    # user = User.new(email: "test@test.com", password: nil)
    refute user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  # More compact Rails-style version:
  # test "validations for blank email and password" do
  #   user = User.new(email: "", password: "")

  #   assert_not user.valid?  # ensure the user is invalid

  #   # Check error messages concisely
  #   [:email, :password].each do |field|
  #     assert_includes user.errors[field], "can't be blank", "#{field} should not be blank"
  #   end
  # end
end
