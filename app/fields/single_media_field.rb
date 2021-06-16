require "administrate/field/belongs_to"

class SingleMediaField < Administrate::Field::BelongsTo
  def to_s
    data.file.attached? ? data.file : '#'
  end
end
