class PocketItemViewController < UIViewController
  attr_accessor :item

  def viewDidLoad
    super

    self.title = '保存した記事'
    setToolbar

    itemView = PocketItemView.setContent(self, item)
    itemView.title_label.addGestureRecognizer(UILongPressGestureRecognizer.alloc.initWithTarget(self, action: 'do_action'))
    itemView.bookmark_button.addTarget(self, action: 'load_bookmarks', forControlEvents: UIControlEventTouchUpInside)
    self.view.addSubview itemView
  end

  def setToolbar
    bookmark_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemAdd, target: self, action: 'bookmark'
    )
    archive_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemOrganize, target: self, action: 'archive'
    )
    action_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemAction, target: self, action: 'do_action'
    )
    flexible_space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFlexibleSpace, target: nil, action: nil
    )
    fixed_space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFixedSpace, target: nil, action: nil
    )
    fixed_space.width = 40
    toolbar_items = [flexible_space, bookmark_button, fixed_space, archive_button, fixed_space, action_button]

    self.navigationController.setToolbarHidden(false, animated: false)
    self.navigationController.toolbar.translucent = false
    self.setToolbarItems(toolbar_items, animated: false)
  end

  def attributedLabel(label, didSelectLinkWithURL: url)
    pocket_web_view_controller = PocketWebViewController.new
    pocket_web_view_controller.item = item
    self.navigationController.pushViewController(pocket_web_view_controller, animated: true)
  end

  def bookmark
    bookmark_view_controller = HTBHatenaBookmarkViewController.new
    bookmark_view_controller.URL = item.url.url_encode.nsurl
    self.presentViewController(bookmark_view_controller, animated: true, completion: nil)
  end

  def archive
    # Archive Item
  end

  def do_action
    self.presentViewController(
      UrlActionController.alloc.initWithActivities([item.url.url_encode.nsurl]),
      animated: true,
      completion: nil
    )
  end

  def load_bookmarks
    comment_url = "http://b.hatena.ne.jp/bookmarklet.touch?mode=comment&iphone_app=1&url=#{item.url.url_encode}".nsurl
    bookmark_comment_controller = BookmarkCommentController.new.tap{|c| c.url = comment_url }
    self.navigationController.pushViewController(bookmark_comment_controller, animated: true)
  end
end
