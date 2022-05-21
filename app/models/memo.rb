class Memo < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :content, unless: :was_attached?
  end
  belongs_to :user
  has_one_attached :image

  def was_attached?
    self.image.attached?
  end
end
