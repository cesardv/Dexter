class Drop < Struct.new(:attributes)
  FILE = 'file'
  REDIRECT = 'redirect'
  TYPES = [FILE, REDIRECT]

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
    Drop.instantiate(ActiveSupport::JSON.decode(attributes).with_indifferent_access)
  end

  def self.create(attributes)
    id = attributes[:id]
    REDIS.set(id, attributes.to_json)
    Drop.instantiate(attributes.with_indifferent_access)
  end

  private
  def self.instantiate(attributes)
    type = attributes[:type]
    if type == FILE
      FileDrop.new(attributes)
    else
      Redirect.new(attributes)
    end
  end
end
