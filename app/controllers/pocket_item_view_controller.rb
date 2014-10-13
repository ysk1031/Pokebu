class PocketItemViewController < UIViewController
  attr_accessor :item

  def viewDidLoad
    super

    self.title = 'Item'

    self.navigationController.setToolbarHidden(false, animated: false)
    self.navigationController.toolbar.translucent = false
    self.setToolbarItems([], animated: false)

    @item_view = UIView.alloc.initWithFrame(self.view.bounds)
    @item_view.backgroundColor = UIColor.whiteColor

    @item_body = UIScrollView.new.tap{|v| v.frame = self.view.bounds }
    @item_view.addSubview(@item_body)


    title_font = UIFont.systemFontOfSize(18)
    range = item.title.rangeOfString(item.title)
    @title_label = TTTAttributedLabel.new.tap do |l|
      l.frame = [[15, 20], [self.view.bounds.size.width - 30, 960]]
      l.numberOfLines = 0
      l.textAlignment = NSTextAlignmentLeft
      l.lineBreakMode = NSLineBreakByWordWrapping
      l.setText(item.title, afterInheritingLabelAttributesAndConfiguringWithBlock:
        lambda do |str|
          str.addAttribute(KCTFontAttributeName, value: title_font, range: range)
          return str
        end
      )
      l.sizeToFit
    end
    @title_label.addLinkToURL(NSURL.URLWithString(item.url), withRange: range)
    @title_label.delegate = self
    @item_body.addSubview(@title_label)

    excerpt_font = UIFont.systemFontOfSize(14)
    @excerpt_label = UILabel.new.tap do |l|
      l.frame = [[20, @title_label.bounds.size.height + 30], [self.view.bounds.size.width - 40, 960]]
      l.numberOfLines = 0
      l.textAlignment = NSTextAlignmentLeft
      l.lineBreakMode = NSLineBreakByWordWrapping
      l.text = item.excerpt
      l.font = excerpt_font
      l.sizeToFit
    end
    @item_body.addSubview(@excerpt_label)

    url_font = UIFont.systemFontOfSize(13)
    @url_label = UILabel.new.tap do |l|
      l.frame = [[20, @title_label.bounds.size.height + @excerpt_label.bounds.size.height + 40], [self.view.bounds.size.width - 40, 960]]
      l.numberOfLines = 0
      l.textAlignment = NSTextAlignmentLeft
      l.lineBreakMode = NSLineBreakByWordWrapping
      l.text = item.url
      l.textColor = UIColor.grayColor
      l.font = url_font
      l.sizeToFit
    end
    @item_body.addSubview(@url_label)

    self.view.addSubview(@item_view)
  end

  def attributedLabel(label, didSelectLinkWithURL: url)
    pocket_web_view_controller = PocketWebViewController.new
    pocket_web_view_controller.item = item
    self.navigationController.pushViewController(pocket_web_view_controller, animated: true)
  end
end
