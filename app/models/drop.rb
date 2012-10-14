class Drop < Struct.new(:attributes)
  FILE = 'file'
  REDIRECT = 'redirect'
  TYPES = [FILE, REDIRECT]
  include ActiveModel::Validations
  attr_accessor :add_errors, :persisted

  TYPES.each do |type|
    define_method "#{type}?" do
      self.type == type
    end
  end
  
  validates :type, :presence => true, :inclusion => {:in => TYPES}
  validates :id, :presence => true
  validate :validate_add_errors

  [:type, :id, :redirect_url, :content_type].each do |attribute|
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

    drop = Drop.instantiate(ActiveSupport::JSON.decode(attributes).with_indifferent_access)
    drop.persisted = true

    drop
  end

  def self.create(attributes)
    id = attributes[:id]
    content_type = attributes[:file].try(:content_type)

    existing_drop = Drop.find_by_id(id)

    drop_attributes = attributes.with_indifferent_access.merge(:content_type => content_type)
    drop = Drop.instantiate(drop_attributes)
    unless existing_drop.blank?
      drop.add_errors = {
        :id => ['already taken']
      }
      return drop
    end
    drop.persisted = true

    json_attributes = drop_attributes.except(:file)
    file = drop_attributes[:file]
    if file
      REDIS.set(file_key_for(id), file.read)
    end

    REDIS.set(id, json_attributes.to_json) if drop.valid?

    drop
  end

  def self.file_key_for(id)
    "#{id}:file"
  end

  def model_name
    'drop'
  end

  def to_key
    self.persisted? ? self.id : nil
  end

  def to_model
    self
  end

  def persisted?
    self.persisted
  end

  def to_param
    self.id
  end

  def file=(file)
    self.attributes ||= Hash.new
    self.attributes[:file] = file
  end

  def file
    file_data = REDIS.get(Drop.file_key_for(self.id))
    return nil if file_data.nil?
    FileDrop::RedisFile.new(file_data, self.content_type)
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
