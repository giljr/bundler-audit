# email:string
# pasword_digest:string
#
# password:string virtual
# password_digest:string virtual
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, presence: true, length: {minimum: 6}, confirmation: true
end
