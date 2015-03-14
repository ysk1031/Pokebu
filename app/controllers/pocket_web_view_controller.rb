class PocketWebViewController < UIViewController
  include Pokebu::PocketItemHandler
  include Pokebu::BookmarkActivity

  attr_accessor :item

  def viewDidLoad
    super

    self.title = item.title
    self.view.backgroundColor = UIColor.whiteColor
    setToolbar

    @webView = UIWebView.new.tap do |v|
      v.frame           = self.view.bounds
      v.scalesPageToFit = true
      v.backgroundColor = UIColor.whiteColor
      v.delegate        = self
      v.loadRequest(NSURLRequest.requestWithURL(item.url.url_encode.nsurl))
    end
    self.view.addSubview @webView

    setIndicator
    @indicator.startAnimating
    self.view.addSubview @indicator
  end

  def setToolbar
    @back_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(101, target: self, action: 'go_back')
    @back_button.enabled = false
    reload_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemRefresh, target: self, action: 'reload'
    )
    bookmark_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemAdd, target: self, action: 'bookmark'
    )
    archive_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemOrganize, target: self, action: 'alertArchive'
    )
    action_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemAction, target: self, action: 'do_action'
    )
    flexible_space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFlexibleSpace, target: nil, action: nil
    )

    toolbar_items = [
      @back_button,
      flexible_space,
      reload_button,
      flexible_space,
      bookmark_button,
      flexible_space,
      archive_button,
      flexible_space,
      action_button
    ]
    self.navigationController.setToolbarHidden(false, animated: false)
    self.navigationController.toolbar.translucent = false
    self.setToolbarItems(toolbar_items, animated: false)
  end

  def setIndicator
    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray).tap do |i|
      i.center           = [self.view.center.x, self.view.center.y - 100]
      i.hidesWhenStopped = true
    end
  end

  def go_back
    @webView.goBack
  end

  def reload
    @webView.reload
  end

  def do_action
    self.presentViewController(
      UrlActionController.alloc.initWithActivities([item.url.url_encode.nsurl]),
      animated: true,
      completion: nil
    )
  end

  def webViewDidFinishLoad(webView)
    @back_button.enabled = webView.canGoBack
    @indicator.stopAnimating
  end
end
