require 'administrate/field/active_storage'

class MediaObject < ApplicationRecord

  has_one_attached :file
  validates :file, :presence => true

	HERO = [1920, 500].freeze
	TILE = [540, 360].freeze
	SMALLTILE = [255, 200].freeze
	THUMBNAIL = [nil, 100].freeze

end
