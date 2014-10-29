class PocketWebViewController < UIViewController
  attr_accessor :item

  def viewDidLoad
    super

    self.title = item.title

    @back_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(101, target: self, action: 'go_back')
    @reload_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemRefresh, target: self, action: 'reload'
    )
    @action_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemAction, target: self, action: 'do_action'
    )
    flexible_space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFlexibleSpace, target: nil, action: nil
    )

    toolbar_items = [
      @back_button,
      flexible_space,
      @reload_button,
      flexible_space,
      @action_button
    ]
    self.navigationController.setToolbarHidden(false, animated: false)
    self.navigationController.toolbar.translucent = false
    self.setToolbarItems(toolbar_items, animated: false)

    @web_view = UIWebView.new.tap do |v|
      v.scalesPageToFit = true
      v.backgroundColor = UIColor.whiteColor
      v.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString(item.url)))
      v.delegate = self
    end
    self.view = @web_view
  end

  def go_back
    @web_view.goBack
  end

  def reload
    @web_view.reload
  end

  def do_action
    self.presentViewController(
      UrlActionController.alloc.initWithActivities([NSURL.URLWithString(item.url)]),
      animated: true,
      completion: nil
    )
  end

  def webViewDidFinishLoad(web_view)
    @back_button.enabled = web_view.canGoBack
  end
end
