class CustomUIApplication < UIApplication
  def openURL(url)
    if !url.host.nil? && url.host.isEqualToString("getpocket.com")
      notificationCenter = NSNotificationCenter.defaultCenter
      notificationCenter.postNotificationName("PokebuOpenPocketAuthNotification", object: url)
      return
    end

    super
  end
end