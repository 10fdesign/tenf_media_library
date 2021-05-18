require "administrate/field/has_many"

class ManyMediaField < Administrate::Field::HasMany
  def to_s
    data
  end
end
