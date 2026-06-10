require 'test_helper'

class RegistrationsFlowTest < ActionDispatch::IntegrationTest
  test 'usuario_pode_registrar_com_sucesso' do
    get sign_up_path   # visit the registration page
    assert_response :success

    post sign_up_path, params: {
      user: {
        email: 'newuser@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }

    # After creating the account, it should redirect
    assert_redirected_to root_path
    follow_redirect!

    assert_equal 'Successfully created account!', flash[:notice]
    # assert_select ".alert-success", "Successfully created account!"
  end

  test 'falha_registro_usuario_com_dados_invalidos' do
    get sign_up_path
    assert_response :success

    post sign_up_path, params: {
      user: {
        email: '', # invalid
        password: 'password123',
        password_confirmation: 'wrong' # mismatch
      }
    }

    # No redirect: it should re-render the form
    assert_response :success

    # Check for flash alert
    # assert_equal "Failed to create account. Please try again.", flash[:alert]
    assert_select '.alert-danger', 'Failed to create account. Please try again.'

    # Ensure the form is still visible
    assert_select 'form'
  end
end

# | Assertion                                                                      | Layer tested         | What it checks                                                                                     | Pros                                                                   | Cons                                                                        |
# |--------------------------------------------------------------------------------|----------------------|----------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|-----------------------------------------------------------------------------|
# | `assert_equal "Failed to create account. Please try again.", flash[:alert]`    | **Controller layer** | Verifies that the controller sets the flash message correctly in memory                            | Simple, fast, ensures business logic works                             | Doesn’t guarantee the message is rendered in the view                       |
# | `assert_select ".alert-danger", "Failed to create account. Please try again."` | **View/UI layer**    | Verifies that the rendered HTML contains the message in a `.alert-danger` element (what user sees) | Ensures the user actually sees the message in the browser (end-to-end) | More fragile: can break if CSS classes/markup change, even if logic is fine |
# |--------------------------------------------------------------------------------|----------------------|----------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|-----------------------------------------------------------------------------|
