class FileDrop < Drop


  class RedisFile < Struct.new(:file_data)
    
    def read
      self.file_data
    end
  end
end
