require 'test_helper'

class AboutControllerTest < ActionDispatch::IntegrationTest
  test 'deve acessar a página sobre' do
    get about_path
    assert_response :success
  end
end

# Docs:
# https://api.rubyonrails.org/classes/ActionDispatch/Integration/RequestHelpers.html - Rest Methods
# https://api.rubyonrails.org/classes/ActionDispatch/Assertions/ResponseAssertions.html - Assertions
