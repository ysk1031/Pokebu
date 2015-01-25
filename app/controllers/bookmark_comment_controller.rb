class BookmarkCommentController < UIViewController
  attr_accessor :url

  def viewDidLoad
    super

    self.title = "ブックマーク"

    @back_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(101, target: self, action: 'go_back')
    reload_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemRefresh, target: self, action: 'reload'
    )
    flexible_space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFlexibleSpace, target: nil, action: nil
    )
    fixed_space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFixedSpace, target: nil, action: nil
    )
    fixed_space.width = 50

    toolbar_items = [
      @back_button,
      fixed_space,
      reload_button,
      flexible_space
    ]

    self.navigationController.setToolbarHidden(false, animated: false)
    self.navigationController.toolbar.translucent = false
    self.setToolbarItems(toolbar_items, animated: false)

    @web_view = UIWebView.new.tap do |v|
      v.scalesPageToFit = true
      v.backgroundColor = UIColor.whiteColor
      v.loadRequest(NSURLRequest.requestWithURL url)
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

  def webViewDidFinishLoad(web_view)
    @back_button.enabled = web_view.canGoBack
  end
end
