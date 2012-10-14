class FileDrop < Drop
  validates :file, :presence => true

  class RedisFile < Struct.new(:file_data)
    
    def read
      self.file_data
    end
  end
end
