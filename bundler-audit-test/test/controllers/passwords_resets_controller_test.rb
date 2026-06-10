require 'test_helper'

##
# Integration tests for the PasswordResetsController.
# Covers the full password reset flow:
# - requesting a reset
# - receiving an email
# - visiting the edit form with valid/invalid tokens
# - updating the password
#
class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test 'deve exibir o formulário de redefinição de senha' do
    get password_reset_path
    assert_response :success
  end

  test 'deve enviar email de redefinição de senha' do
    user = users(:valid_user)

    # Assert that an email is sent when requesting a reset
    assert_emails 1 do
      post password_reset_path, params: {email: user.email}
    end

    # Assert redirect and flash message
    assert_redirected_to root_path
    follow_redirect!
    assert_match(
      'If an account with that email was found, we have sent a link to reset your password.',
      flash[:notice]
    )
  end

  test 'deve exibir o formulário de edição com token válido' do
    user = users(:valid_user)
    token = user.signed_id(purpose: 'password_reset')

    get password_reset_edit_path(token: token)
    assert_response :success
  end

  test 'deve redirecionar para sign_in com token inválido' do
    get password_reset_edit_path(token: 'invalidtoken')

    assert_redirected_to sign_in_path
    follow_redirect!
    assert_match 'Your token has expired. Please try again.', flash[:alert]
  end

  test 'deve atualizar a senha com token válido' do
    user = users(:valid_user)
    token = user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)

    patch password_reset_edit_path(token: token), params: {
      user: {
        password: 'newpassword',
        password_confirmation: 'newpassword'
      }
    }

    user.reload

    assert user.authenticate('newpassword'), 'Expected user password to be updated'
    assert_redirected_to sign_in_path
    follow_redirect!
    assert_match 'Your password was reset successfully. Please sign in.', flash[:notice]
  end

  test 'não deve atualizar a senha com token inválido' do
    patch password_reset_path(token: 'invalidtoken'), params: {
      user: {
        password: 'newpassword',
        password_confirmation: 'newpassword'
      }
    }

    assert_response :not_found
  end
end

# Docs:
# - https://api.rubyonrails.org/classes/ActionDispatch/Integration/RequestHelpers.html
# - https://api.rubyonrails.org/classes/ActionDispatch/Assertions/ResponseAssertions.html
