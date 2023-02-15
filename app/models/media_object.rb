require 'administrate/field/active_storage'

class MediaObject < ApplicationRecord

  after_create_commit :handle_pdf

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
      converted_file_path = File.join(Dir.tmpdir, "#{file_name}-#{Time.now.strftime("%Y%m%d")}-#{$$}-#{rand(0x100000000).to_s(36)}.jpg")
      puts "converted_file_path #{converted_file_path}"
      converted_file_path.gsub!(".pdf", "")
      puts "converted_file_path #{converted_file_path}"
      puts "quality, jpeg 60"
      convert_result = MiniMagick::Tool::Convert.new do |convert|
        convert.background "white"
        convert.flatten
        convert.density 150
        convert.quality 60
        convert << pdf.pages.first.path
        convert << converted_file_path
      end
      puts "convert_result #{convert_result}"

      attach_result = self.preview.attach(io: File.open(converted_file_path), filename: file_name.to_s.gsub(".pdf", ".jpg"), content_type: "image/jpeg")
      puts "attach_result #{attach_result}"
      rm_result = FileUtils.rm(converted_file_path)
      puts "rm_result #{rm_result}"
    end
  end

end
