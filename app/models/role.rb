class Role < ApplicationRecord
  ADMIN = Role.find_by(name: "Admin").id
  REGULAR_USER = Role.find_by(name: "RegularUser").id

  has_many :assignments

  validates :name,
            presence: true,
            uniqueness: {case_sensitive: false}

end
