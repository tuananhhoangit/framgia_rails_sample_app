class User < ApplicationRecord
  before_save{email.downcase!}

  validates :name, presence: true, length: {Settings.user.name_max_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {Settings.user.email_max_length},
    format: {width: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {Settings.user.password_min_length}

  has_secure_password
end
