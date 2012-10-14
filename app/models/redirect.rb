class Redirect < Drop
  validates :redirect_url, :presence => true, :url => true
end
