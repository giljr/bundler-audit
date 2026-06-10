# Preview all emails at http://localhost:3000/rails/mailers/password_mailer
class PasswordMailerPreview < ActionMailer::Preview
  # Preview the "Reset Password" email
  # URL: http://localhost:3000/rails/mailers/password_mailer/reset
  def reset
    # Use the first user from the database or a fake user for preview
    user = User.first || User.new(email: 'preview@example.com')
    token = user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)

    # Provide the user via `with(params: {...})` so the mailer can access params[:user]
    PasswordMailer.with(user: user, token: token).reset
  end
end

# ---------------------------------------------------------------
# How to use:
# - Open in the browser (development environment):
#   http://localhost:3000/rails/mailers/password_mailer/reset
# - The preview renders the email exactly as it would be sent:
#   - @user and @token variables are correctly populated
#   - Subject, from/to headers, and email body appear as expected
#   - EML file can be downloaded to test in an email client
# ---------------------------------------------------------------

# Improvements of this preview setup:
# | Improvement                   | Description                                                                                     |
# |-------------------------------|-------------------------------------------------------------------------------------------------|
# | Use a real user or fixture     | Picks the first user from the database or creates a fake user for preview purposes             |
# | Supports token-based emails    | Generates a token to display realistic password reset links in the preview                      |
# | Matches production logic       | Calls the mailer method exactly as in the app, ensuring the preview is accurate                |
# | Browser-friendly               | Accessible at http://localhost:3000/rails/mailers/password_mailer/reset for visual inspection |
