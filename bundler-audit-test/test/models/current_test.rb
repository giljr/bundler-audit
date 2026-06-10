# test/models/current_test.rb
require 'test_helper'

class CurrentTest < ActiveSupport::TestCase
  # Load fixtures - fixtures give you pre-saved records.
  fixtures :users

  test 'pode armazenar e recuperar o usuário' do
    # Use the fixture user
    user = users(:valid_user)
    # user = User.new(email: "test@example.com", password: "password")

    # Set the current user
    Current.user = user

    # Check if it returns the same user
    assert_equal user, Current.user
  end

  test 'o usuário atual é nulo por padrão' do
    Current.user = nil
    assert_nil Current.user
  end
end

# | Observation | Explanation |
# |-------------|------------|
# | Let us explain | These tests verify how the `Current` object handles the current user. |
# | Tests | The first test ensures that a user can be stored and retrieved correctly, while the second confirms that, by default, the current user is `nil` when not set.|
# | Test behavior | These tests are checking the behavior of your `Current` object (a Rails `ActiveSupport::CurrentAttributes` class used to hold request-specific state, such as the logged-in user). |
# | Current class | The `Current` class is used to store thread-safe “current” attributes, often for the logged-in user in Rails. |
# | Generator | $ bin/rails generate test_unit:model current |
# https://docs.seattlerb.org/minitest/Minitest/Assertions.html
