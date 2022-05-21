class Memo < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :content
  end
  belongs_to :user
  has_one_attached :image
end
