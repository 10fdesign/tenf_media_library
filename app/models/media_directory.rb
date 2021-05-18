class MediaDirectory < ApplicationRecord

  has_many :subdirectories, class_name: 'MediaDirectory', foreign_key: 'parent_directory_id'
  belongs_to :parent_directory, class_name: 'MediaDirectory', foreign_key: 'parent_directory_id', optional: true

end
