class NSString
  def url_encode
    self.stringByAddingPercentEscapesUsingEncoding NSUTF8StringEncoding
  end

  def nsurl
    NSURL.URLWithString self
  end
end
