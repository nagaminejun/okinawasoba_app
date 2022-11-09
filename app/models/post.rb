class Post < ApplicationRecord
  belongs_to :user
  
  validates :store_name, length: { maximum: 30 }, presence: true
  validates :comment, length: { maximum: 100 }
  
  def user
    User.find(self.user_id)
  end
  
end
