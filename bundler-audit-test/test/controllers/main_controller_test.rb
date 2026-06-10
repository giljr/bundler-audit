require 'test_helper'

class MainControllerTest < ActionDispatch::IntegrationTest
  test 'deve acessar a página principal' do
    get root_path
    assert_response :success
  end
end

# Docs:
# https://api.rubyonrails.org/classes/ActionDispatch/Integration/RequestHelpers.html
# https://api.rubyonrails.org/classes/ActionDispatch/Assertions/ResponseAssertions.html
