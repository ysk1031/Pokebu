class PocketWebViewController < UIViewController
  attr_accessor :item

  def viewDidLoad
    super

    self.title = item.title

    @web_view = UIWebView.new.tap do |v|
      v.scalesPageToFit = true
      v.backgroundColor = UIColor.whiteColor
      v.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString(item.url)))
      v.delegate = self
    end
    self.view = @web_view
  end
end
