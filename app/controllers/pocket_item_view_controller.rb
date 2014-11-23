class PocketItemViewController < UIViewController
  attr_accessor :item

  def viewDidLoad
    super

    self.title = 'Item'

    # ↓さすがに長過ぎるので、後でviewに分離する
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


    @item_view = UIView.alloc.initWithFrame(self.view.bounds)
    @item_view.backgroundColor = UIColor.whiteColor

    @item_body = UIScrollView.new.tap{|v| v.frame = self.view.bounds }
    @item_view.addSubview(@item_body)

    # TTTAttributedLabel, UILabelの高さの調整、このやり方だと微妙そう...
    @title_label = TTTAttributedLabel.new.tap do |l|
      l.frame = [[15, 20], [self.view.bounds.size.width - 30, 960]]
      l.numberOfLines = 0
      l.textAlignment = NSTextAlignmentLeft
      l.lineBreakMode = NSLineBreakByWordWrapping
      l.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter
      l.setText(item.title, afterInheritingLabelAttributesAndConfiguringWithBlock:
        lambda{|str| return str }
      )
      l.sizeToFit
    end
    link_attributes = {
      KCTUnderlineStyleAttributeName => NSNumber.numberWithInt(KCTUnderlineStyleNone),
      KCTForegroundColorAttributeName => UIColor.blueColor
    }
    @title_label.linkAttributes = link_attributes
    range = item.title.rangeOfString(item.title)
    @title_label.addLinkToURL(NSURL.URLWithString(item.url), withRange: range)
    @title_label.delegate = self
    @item_body.addSubview(@title_label)

    excerpt_font = UIFont.systemFontOfSize(14)
    @excerpt_label = UILabel.new.tap do |l|
      l.frame = [[20, @title_label.bottom + 10], [self.view.bounds.size.width - 40, 960]]
      l.textAlignment = NSTextAlignmentLeft
      l.lineBreakMode = NSLineBreakByTruncatingTail
      l.text = item.excerpt
      l.font = excerpt_font
      l.numberOfLines = 5
      l.sizeToFit
    end
    @item_body.addSubview(@excerpt_label)

    url_font = UIFont.systemFontOfSize(13)
    @url_label = UILabel.new.tap do |l|
      l.frame = [[20, @excerpt_label.bottom + 10], [self.view.bounds.size.width - 40, 960]]
      l.textAlignment = NSTextAlignmentLeft
      l.lineBreakMode = NSLineBreakByCharWrapping
      l.text = item.url
      l.textColor = UIColor.grayColor
      l.font = url_font
      l.numberOfLines = 0
      l.sizeToFit
    end
    @item_body.addSubview(@url_label)

    @date_label = UILabel.new.tap do |l|
      l.frame = [[20, @url_label.bottom + 5], [self.view.bounds.size.width - 40, 960]]
      l.textAlignment = NSTextAlignmentLeft
      l.lineBreakMode = NSLineBreakByCharWrapping
      l.text = "#{item.added_time}に追加"
      l.textColor = UIColor.grayColor
      l.font = url_font
      l.numberOfLines = 1
      l.sizeToFit
    end
    @item_body.addSubview(@date_label)

    @first_border = UIView.new.tap do |v|
      v.frame = [[10, @date_label.bottom + 10], [self.view.bounds.size.width - 20, 0.5]]
      v.backgroundColor = UIColor.grayColor
    end
    @item_body.addSubview(@first_border)

    @hatebu_count_label = TTTAttributedLabel.new.tap do |l|
      l.frame = [[15, @first_border.bottom + 10], [self.view.bounds.size.width - 30, 960]]
      l.numberOfLines = 1
      l.textAlignment = NSTextAlignmentLeft
      l.lineBreakMode = NSLineBreakByWordWrapping
      l.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter
      l.setText("Bookmark: #{item.bookmark_count}", afterInheritingLabelAttributesAndConfiguringWithBlock:
        lambda{|str| return str }
      )
      l.sizeToFit
    end
    @hatebu_count_label.linkAttributes = link_attributes
    range = "Bookmark: #{item.bookmark_count}".rangeOfString("Bookmark: #{item.bookmark_count}")
    @hatebu_count_label.addLinkToURL(
      NSURL.URLWithString("http://b.hatena.ne.jp/bookmarklet.touch?mode=comment&iphone_app=1&url=#{item.url}"),
      withRange: range
    )
    @hatebu_count_label.delegate = self
    @item_body.addSubview(@hatebu_count_label)

    @second_border = UIView.new.tap do |v|
      v.frame = [[10, @hatebu_count_label.bottom + 10], [self.view.bounds.size.width - 20, 0.5]]
      v.backgroundColor = UIColor.grayColor
    end
    @item_body.addSubview(@second_border)

    self.view.addSubview(@item_view)
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
    bookmark_view_controller.URL = NSURL.URLWithString(item.url)
    self.presentViewController(bookmark_view_controller, animated: true, completion: nil)
  end

  def do_action
    self.presentViewController(
      UrlActionController.alloc.initWithActivities([NSURL.URLWithString(item.url)]),
      animated: true,
      completion: nil
    )
  end
end
