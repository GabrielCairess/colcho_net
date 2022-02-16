class Room < ApplicationRecord
  extend FriendlyId
  has_many :reviews, dependent: :destroy
  has_many :reviewed_rooms, through: :reviews, source: :room

  validates_presence_of :title, :location, :description
  validates_presence_of :slug
  validates_length_of :title, minimum: 5, allow_blank: false
  validates_length_of :location, minimum: 5, allow_blank: false
  validates_length_of :description, minimum: 5, allow_blank: false
  belongs_to :user

  friendly_id :title, use: [:slugged, :history]

  scope :most_recent, ->{ order('created_at DESC') }

  def complete_name
    "#{title}, #{location}"
  end

  def self.search(query)
    if query.present?
      where(['location ILIKE :query OR
        title ILIKE :query OR
        description LIKE :query', query: "%#{query}%"])
    else
      unscoped
    end
  end
end
