class FileDrop < Drop

  def file
    file_data = REDIS.get(Drop.file_key_for(self.id))
    return nil if file_data.nil?
    RedisFile.new(file_data)
  end

  class RedisFile < Struct.new(:file_data)
    
    def read
      self.file_data
    end
  end
end
