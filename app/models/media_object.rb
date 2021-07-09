require 'administrate/field/active_storage'

class MediaObject < ApplicationRecord

	belongs_to :media_directory, optional: true
  has_one_attached :file
  has_one_attached :preview
  validates :file, :presence => true

	HERO = [1920, 500].freeze
	TILE = [540, 360].freeze
	SMALLTILE = [255, 200].freeze
	THUMBNAIL = [nil, 100].freeze

  def image
    if preview.attached?
      return preview
    elsif file.attached?
      return file
    else
      puts "uh oh! calling #image on media_object with no attached file or preview :("
      return nil
    end
  end

end
