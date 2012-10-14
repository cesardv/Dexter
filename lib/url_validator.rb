class UrlValidator < ActiveModel::EachValidator
  # yuuuup copypasta.
  # http://stackoverflow.com/questions/7167895/whats-a-good-way-to-validate-links-urls-in-rails-3
  
  def validate_each(record, attribute, value)
    begin
      uri = URI.parse(value)
      resp = uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      resp = false
    end
    unless resp == true
      record.errors[attribute] << (options[:message] || "is not an url")
    end
  end
end

