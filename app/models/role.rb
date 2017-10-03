class Role < ApplicationRecord
  has_many :assignments

  validates :name,
            presence: true,
            uniqueness: {case_sensitive: false}

end
