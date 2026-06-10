require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test 'deve exibir o formulário de cadastro' do
    get sign_up_path
    assert_response :success
  end
end

# Docs:
# https://api.rubyonrails.org/classes/ActionDispatch/Integration/RequestHelpers.html
# https://api.rubyonrails.org/classes/ActionDispatch/Assertions/ResponseAssertions.html
