class Memo < ApplicationRecord
  with_optinos presence: true do
    validates: title
    validates: content
  end
end
