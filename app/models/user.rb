class User < ApplicationRecord
  before_save { self.email = email.downcase } #記述されているselfは、メソッドを呼び出している時点でのユーザーオブジェクトを指しています。
  
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
end