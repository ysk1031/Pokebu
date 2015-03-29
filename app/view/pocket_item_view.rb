class PocketItemView < UIScrollView
  attr_accessor :title_label, :bookmark_button

  GOOGLE_FAVICON_URL = "http://www.google.com/s2/favicons"
  SQUARE_IMAGE_SIDE = 80

  @@placeholder_favicon = UIImage.imageNamed('no_favicon')

  def self.setContent(controller, item)
    self.alloc.initWithFrame(controller, item)
  end


  def initWithFrame(controller, item)
    super(controller.view.bounds)
    self.backgroundColor = UIColor.whiteColor

    fullWidth = controller.view.bounds.size.width

    # favicon
    item.url =~ %r{\Ahttps?://((\w|-|.)+?)/}
    url_domain = $1

    faviconView = UIImageView.new.tap do |v|
      v.frame = [[10, 15], [16, 16]]
      v.setImageWithURL(
        "#{GOOGLE_FAVICON_URL}?domain=#{url_domain}".nsurl,
        placeholderImage: @@placeholder_favicon
      )
    end
    self.addSubview faviconView

    # title
    titleLabelOriginX = faviconView.right + 8
    titleLabel = TTTAttributedLabel.new.tap do |l|
      l.frame = [[titleLabelOriginX, 15], [fullWidth - titleLabelOriginX - 10, 960]]
      l.numberOfLines = 0
      l.font = UIFont.boldSystemFontOfSize(18)
      l.lineBreakMode = NSLineBreakByWordWrapping
      l.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter
      l.setText(item.title, afterInheritingLabelAttributesAndConfiguringWithBlock:
        lambda{|str| return str }
      )
      l.sizeToFit
      l.linkAttributes = linkAttributes
      l.activeLinkAttributes = activeLinkAttributes
      l.addLinkToURL(
        item.url.nsurl,
        withRange: item.title.rangeOfString(item.title)
      )
      l.delegate = controller
    end
    self.addSubview titleLabel
    self.title_label = titleLabel

    # image
    unless item.asset_src.nil?
      imageView = UIImageView.new.tap do |v|
        v.contentMode = UIViewContentModeScaleAspectFit
        v.setImageWithURL(item.asset_src.nsurl)
        v.frame = [[fullWidth - SQUARE_IMAGE_SIDE - 10, titleLabel.bottom + 10], [SQUARE_IMAGE_SIDE, SQUARE_IMAGE_SIDE]]
      end
      self.addSubview imageView
    end

    # excerpt
    excerptLabelWidth =
      if imageView.nil?
        fullWidth - titleLabelOriginX - 10
      else
        fullWidth - titleLabelOriginX - SQUARE_IMAGE_SIDE - 15
      end
    excerptLabel = UILabel.new.tap do |l|
      l.frame = [[titleLabelOriginX, titleLabel.bottom + 10], [excerptLabelWidth, 960]]
      l.lineBreakMode = NSLineBreakByTruncatingTail
      l.text = item.excerpt
      l.font = UIFont.systemFontOfSize(14)
      l.numberOfLines = 6
      l.sizeToFit
    end
    self.addSubview excerptLabel

    # URL
    urlLabelOriginY =
      if imageView.nil?
        excerptLabel.bottom + 10
      else
        excerptLabel.bottom > imageView.bottom ? excerptLabel.bottom + 10 : imageView.bottom + 10
      end
    urlLabel = UILabel.new.tap do |l|
      l.frame = [[titleLabelOriginX, urlLabelOriginY], [fullWidth - titleLabelOriginX - 10, 960]]
      l.lineBreakMode = NSLineBreakByCharWrapping
      l.text = item.url
      l.textColor = UIColor.grayColor
      l.font = UIFont.systemFontOfSize(13)
      l.numberOfLines = 0
      l.sizeToFit
    end
    self.addSubview urlLabel

    # アイテムの追加日
    dateLabel = UILabel.new.tap do |l|
      l.frame = [[titleLabelOriginX, urlLabel.bottom + 5], [fullWidth - titleLabelOriginX - 10, 960]]
      l.lineBreakMode = NSLineBreakByCharWrapping
      l.text = "#{item.added_time} に追加"
      l.textColor = UIColor.grayColor
      l.font = UIFont.systemFontOfSize(13)
      l.numberOfLines = 1
      l.sizeToFit
    end
    self.addSubview dateLabel

    # 区切り線1
    firstBorder = borderLine(dateLabel.bottom + 10, fullWidth)
    self.addSubview firstBorder

    # はてブ数
    bookmark_text = bookmarkDisplayText item
    bookmarkCountButton = UIButton.buttonWithType(UIButtonTypeSystem).tap do |b|
      b.frame = [[10, firstBorder.bottom], [fullWidth - 20, 40]]
      b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft
      b.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
      b.titleLabel.font = UIFont.systemFontOfSize(16)
      b.titleLabel.lineBreakMode = NSLineBreakByWordWrapping
      b.setAttributedTitle(bookmark_text, forState: UIControlStateNormal)
    end
    self.addSubview bookmarkCountButton
    self.bookmark_button = bookmarkCountButton
    loadBookmarkCount item

    # 区切り線2
    secondBorder = borderLine(bookmarkCountButton.bottom, fullWidth)
    self.addSubview secondBorder

    self.setContentSize [fullWidth, secondBorder.bottom + 100]

    self
  end

  def bookmarkDisplayText(item)
    bookmark_text = "#{item.bookmark_count || 0} ブックマーク"
    bold_text_range = NSMakeRange(0, bookmark_text =~ /\s/)

    ns_mutable_bookmark_text = NSMutableAttributedString.alloc.initWithString(bookmark_text)
    ns_mutable_bookmark_text.addAttribute(NSForegroundColorAttributeName,
      value: UIColor.grayColor,
      range: NSMakeRange(0, bookmark_text.length)
    )
    ns_mutable_bookmark_text.addAttribute(NSForegroundColorAttributeName,
      value: UIColor.blackColor,
      range: bold_text_range
    )
    ns_mutable_bookmark_text.addAttribute(NSFontAttributeName,
      value: UIFont.boldSystemFontOfSize(16),
      range: bold_text_range
    )
  end

  def linkAttributes
    {
      KCTUnderlineStyleAttributeName => NSNumber.numberWithInt(KCTUnderlineStyleNone),
      KCTForegroundColorAttributeName => UIColor.themeColorLightGreen
    }
  end

  def activeLinkAttributes
    {
      KCTUnderlineStyleAttributeName => NSNumber.numberWithInt(KCTUnderlineStyleNone),
      KCTForegroundColorAttributeName => UIColor.themeColorRed
    }
  end

  def borderLine(originY, width)
    UIView.new.tap do |v|
      v.frame = [[10, originY], [width - 20, 0.5]]
      v.backgroundColor = UIColor.grayColor
    end
  end

  def loadBookmarkCount(item)
    Dispatch::Queue.concurrent.async do
      item.getBookmarkCount do |bookmark_count, error|
        Dispatch::Queue.main.async do
          if error.nil?
            bookmark_text = bookmarkDisplayText(item)
            # UIButtonのタイトル変更時のアニメーションのせいで文字がちらつくので、
            # この時のみアニメーションをオフにする
            UIView.setAnimationsEnabled false
            self.bookmark_button.setAttributedTitle(bookmark_text, forState: UIControlStateNormal)
            self.bookmark_button.layoutIfNeeded
            UIView.setAnimationsEnabled true
          end
        end
      end
    end
  end
end
