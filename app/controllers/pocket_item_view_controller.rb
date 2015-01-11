class PocketItemViewController < UIViewController
  attr_accessor :item

  def viewDidLoad
    super

    self.title = '保存アイテム'
    setToolbar

    itemView = PocketItemView.setContent(self, item)
    self.view.addSubview itemView
  end

  def setToolbar
    action_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemAction, target: self, action: 'do_action'
    )
    bookmark_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemAdd, target: self, action: 'bookmark'
    )
    flexible_space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFlexibleSpace, target: nil, action: nil
    )
    fixed_space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFixedSpace, target: nil, action: nil
    )
    fixed_space.width = 50
    toolbar_items = [flexible_space, bookmark_button, fixed_space, action_button]

    self.navigationController.setToolbarHidden(false, animated: false)
    self.navigationController.toolbar.translucent = false
    self.setToolbarItems(toolbar_items, animated: false)
  end

  def attributedLabel(label, didSelectLinkWithURL: url)
    if url.absoluteString =~ %r{http://b.hatena.ne.jp/bookmarklet.touch}
      bookmark_comment_controller = BookmarkCommentController.new
      bookmark_comment_controller.url = url
      self.navigationController.pushViewController(bookmark_comment_controller, animated: true)
    else
      pocket_web_view_controller = PocketWebViewController.new
      pocket_web_view_controller.item = item
      self.navigationController.pushViewController(pocket_web_view_controller, animated: true)
    end
  end

  def bookmark
    bookmark_view_controller = HTBHatenaBookmarkViewController.new
    bookmark_view_controller.URL = item.url.url_encode.nsurl
    self.presentViewController(bookmark_view_controller, animated: true, completion: nil)
  end

  def do_action
    self.presentViewController(
      UrlActionController.alloc.initWithActivities([item.url.url_encode.nsurl]),
      animated: true,
      completion: nil
    )
  end
end
