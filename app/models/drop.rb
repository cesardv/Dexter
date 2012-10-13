class Drop < Struct.new(:attributes)
  FILE = 'file'
  REDIRECT = 'redirect'
  TYPES = [FILE, REDIRECT]
  include ActiveModel::Validations
  
  validates :type, :presence => true

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
    return nil if attributes.blank?

    Drop.instantiate(ActiveSupport::JSON.decode(attributes).with_indifferent_access)
  end

  def self.create(attributes)
    id = attributes[:id]
    drop = Drop.instantiate(attributes.with_indifferent_access)

    REDIS.set(id, attributes.to_json) if drop.valid?

    drop
  end

  private
  def self.instantiate(attributes)
    type = (attributes || Hash.new)[:type]
    if type.blank?
      Drop.new(attributes)
    elsif type == FILE
      FileDrop.new(attributes)
    else
      Redirect.new(attributes)
    end
  end
end
