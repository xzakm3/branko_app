class User < ApplicationRecord
  belongs_to :farm
  has_many :assignments, dependent: :delete_all
  has_many :roles, through: :assignments
  accepts_nested_attributes_for :assignments

  attr_accessor :remember_token, :activation_token
  has_secure_password

  before_save :downcase_email
  before_save :downcase_name
  before_create :create_activation_digest


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,
            presence: true,
            length: { maximum: 50 },
            uniqueness: { case_sensitive: false }

  validates :email,
            presence: true,
            length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: { case_sensitive: false }

  validates :password,
            presence: true,
            length: {minimum: 6},
            allow_nil: true

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def role?(role)
    roles.any? {|r| r.name.underscore.to_sym == role}
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_farm_info_email(death_info, hatch_info)
    FarmMailer.farm_information(self, death_info, hatch_info).deliver_now
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def downcase_name
    self.name = name.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
