class NSString
  def url_encode
    # self.stringByAddingPercentEscapesUsingEncoding NSUTF8StringEncoding
    CFURLCreateStringByAddingPercentEscapes(
      nil,
      self,
      nil,
      "!*'();:@&=+$,/?%#[]",
      KCFStringEncodingUTF8
    )
  end

  def nsurl
    NSURL.URLWithString self
  end
end
