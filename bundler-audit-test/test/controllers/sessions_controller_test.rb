require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'deve encerrar a sessão e redirecionar para a página inicial' do
    delete sign_out_path
    assert_redirected_to root_path
  end
end

# Docs:
# https://api.rubyonrails.org/classes/ActionDispatch/Integration/RequestHelpers.html
# https://api.rubyonrails.org/classes/ActionDispatch/Assertions/ResponseAssertions.html
