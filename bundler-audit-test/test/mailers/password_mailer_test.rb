require 'test_helper'

class PasswordMailerTest < ActionMailer::TestCase
  test 'reset email' do
    # Create a user for testing purposes
    user = users(:valid_user) # Make sure you have a user fixture set up

    # Generate a signed token for the user with the correct purpose - optional
    token = user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)

    # Pass the user and token to the PasswordMailer reset method
    mail = PasswordMailer.with(user: user, token: token).reset.deliver_now

    # Assert that the email subject is correct
    assert_equal 'Reset your password', mail.subject

    # Assert that the email is sent to the correct user
    assert_equal [user.email], mail.to

    # Check that the plain text part contains the reset link phrase
    assert_match(/click the link to reset your password/, mail.text_part.body.encoded.downcase)

    # Check that the HTML part contains the correct phrase
    # Added /i to regex for case-insensitive matching, making it more robust.
    assert_match(/click the link below to reset your password/i, mail.html_part.body.encoded.downcase)

    # Optionally, you can uncomment below to print email content for debugging
    # puts "********************************"
    # puts mail.text_part.body.encoded
    # puts "********************************"
    # puts mail.html_part.body.encoded
    # puts "********************************"
  end
end
