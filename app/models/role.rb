class Role < ApplicationRecord
  ADMIN = 1
  REGULAR_USER = 2

  has_many :assignments

  validates :name,
            presence: true,
            uniqueness: {case_sensitive: false}

end
