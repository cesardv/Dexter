class Drop < Struct.new(:attributes)
  FILE = 'file'
  REDIRECT = 'redirect'

  [:type].each do |attribute|
    define_method "#{attribute}=" do |value|
      self.attributes ||= Hash.new
      self.attributes.merge!(
        attribute => value
      )
    end

    define_method attribute do
      self.attributes ||= Hash.new
      self.attributes[attribute]
    end
  end

  def self.find_by_id(id)
    attributes = REDIS.get(id)
    Drop.new(attributes)
  end

  def self.create(attributes)
    id = attributes[:id]
    REDIS.set(id, attributes)
    Drop.new(attributes)
  end
end
