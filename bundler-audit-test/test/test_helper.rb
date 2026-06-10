ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# Nicer output (RSpec-like)
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  # ❌ Disable automatic DB rollback between tests
  self.use_transactional_tests = true

  # Run tests in parallel
  parallelize(workers: :number_of_processors)

  # Load all fixtures
  fixtures :all
end

module SignInHelper
  # For integration tests
  def log_in_as(user, password: 'password')
    post sign_in_path, params: {email: user.email, password: password}
    follow_redirect! if response.redirect?
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end
