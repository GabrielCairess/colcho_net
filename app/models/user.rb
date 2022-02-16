class User < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates_presence_of :email, :full_name, :location
  validates_length_of :bio, minimum: 5, allow_blank: false
  validates_format_of :email, with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  has_secure_password

  before_create :generate_token

  scope :confirmed, ->{ where('confirmed_at IS NULL') }

  def generate_token
    self.confirmation_token = SecureRandom.urlsafe_base64
  end

  def confirm!
    return if confirmed?

    self.confirmed_at = Time.current
    self.confirmation_token = ''
    save!
  end

  def confirmed?
    confirmed_at.present?
  end

  def self.authenticate(email, password)
    confirmed.find_by(email: email).try(:authenticate, password)
  end
end
