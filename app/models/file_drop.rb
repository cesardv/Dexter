class FileDrop < Drop
  validates :file, :presence => true

  class RedisFile < Struct.new(:file_data, :content_type)
    
    def read
      self.file_data
    end
  end
end
