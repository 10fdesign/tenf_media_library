require "administrate/field/has_many"

class ManyMediaField < Administrate::Field::HasMany
  MEDIA_DEFAULT_LIMIT = 50

  def limit
    options.fetch(:limit, MEDIA_DEFAULT_LIMIT)
  end

  def to_s
    data
  end
end
