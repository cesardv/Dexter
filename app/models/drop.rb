class Drop < Struct.new(:attributes)
  FILE = 'file'
  REDIRECT = 'redirect'
  TYPES = [FILE, REDIRECT]
  include ActiveModel::Validations
  attr_accessor :add_errors
  
  validates :type, :presence => true, :inclusion => {:in => TYPES}
  validates :id, :presence => true
  validate :validate_add_errors

  [:type, :id].each do |attribute|
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
    existing_drop = Drop.find_by_id(id)

    drop = Drop.instantiate(attributes.with_indifferent_access)
    unless existing_drop.blank?
      drop.add_errors = {
        :id => ['already taken']
      }
      return drop
    end

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

  def validate_add_errors
    (self.add_errors || Hash.new).each do |k, v|
      v.each do |error|
        self.errors.add(k, error)
      end
    end
  end
end
