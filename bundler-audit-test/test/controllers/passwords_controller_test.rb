require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_user = users(:valid_user)
    @another_user = users(:another_user)
  end

  test 'deve redirecionar para sign_in se não estiver logado' do
    get edit_password_path
    assert_redirected_to sign_in_path
  end

  test 'deve renderizar a página de edição quando estiver logado' do
    log_in_as(@valid_user)
    get edit_password_path
    assert_response :success
  end

  test 'deve atualizar a senha com parâmetros válidos' do
    log_in_as(@valid_user)
    patch password_path, params: {user: {password: 'newpass123', password_confirmation: 'newpass123'}}
    assert_redirected_to root_path
    assert_equal 'Password updated!', flash[:notice]
  end

  test 'não deve atualizar a senha se a confirmação não corresponder' do
    log_in_as(@valid_user)
    patch password_path, params: {user: {password: 'newpass123', password_confirmation: 'wrong'}}

    assert_response :unprocessable_content   # <-- changed from :success
    assert_select 'form'
  end

  test 'outro usuário também pode atualizar a propria_senha' do
    log_in_as(@another_user, password: 'secret123')
    patch password_path, params: {user: {password: 'anotherpass123', password_confirmation: 'anotherpass123'}}

    assert_redirected_to root_path
    assert_equal 'Password updated!', flash[:notice]

    @another_user.reload
    assert @another_user.authenticate('anotherpass123')
  end
end

# | Feature            | `fixtures :users` + `users(:valid_user)` | `setup` block                            |
# | ------------------ | ---------------------------------------- | ---------------------------------------- |
# | Runs before tests? | Only when you call it                    | Always, before each test                 |
# | Variable scope     | Local to the test method                 | Instance variable available in all tests |
# | DRY?               | No, you repeat the call                  | Yes, once in `setup`                     |
# | Use case           | Quick access for a single test           | Shared preparation for multiple tests    |
# | ------------------ | ---------------------------------------- | ---------------------------------------- |

# Docs:
# https://api.rubyonrails.org/classes/ActionDispatch/Integration/RequestHelpers.html
# https://api.rubyonrails.org/classes/ActionDispatch/Assertions/ResponseAssertions.html
