require 'administrate/field/active_storage'

class MediaObject < ApplicationRecord

	after_create_commit :create_variants, :handle_pdf

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

  def handle_pdf
  	if self.file.content_type.start_with? "application/pdf"
	  	pdf = MiniMagick::Image.open self.file
	    puts "DEBUG"
	    file_name = self.file.attachment.filename
	    puts "file_name #{file_name}"
	    converted_file_path = File.join(Dir.tmpdir, "#{file_name}-#{Time.now.strftime("%Y%m%d")}-#{$$}-#{rand(0x100000000).to_s(36)}.png")
	    puts "converted_file_path #{converted_file_path}"
	    converted_file_path.gsub!(".pdf", "")
	    puts "converted_file_path #{converted_file_path}"
	    convert_result = MiniMagick::Tool::Convert.new do |convert|
	      convert.background "white"
	      convert.flatten
	      convert.density 150
	      convert.quality 100
	      convert << pdf.pages.first.path
	      convert << converted_file_path
	    end
	    puts "convert_result #{convert_result}"
	    
	    attach_result = self.preview.attach(io: File.open(converted_file_path), filename: file_name.to_s.gsub(".pdf", ".png"), content_type: "image/png")
	    puts "attach_result #{attach_result}"
	    rm_result = FileUtils.rm(converted_file_path)
	    puts "rm_result #{rm_result}"
	  end
  end

  def create_variants
		image.analyze
		possible_image_widths = [
			64,
			128,
			256,
			512,
			768,
			1024,
			1536,
			2048,
		]
		img_width = image.blob.metadata[:width]
		img_height = image.blob.metadata[:height]
		ratio = img_height.to_f / img_width.to_f
		possible_image_widths.reject! { |size| size > img_width }
		possible_image_widths.map! { |size| [size, (1 + size * ratio).to_i] }
		possible_image_widths.each do |size|
			variant = image.variant(resize_to_limit: size).processed
		end

		[MediaObject::HERO, MediaObject::TILE, MediaObject::SMALLTILE, MediaObject::THUMBNAIL].each do |media_object_size|
			variant = image.variant(resize_to_limit: media_object_size).processed
		end
	end

end
