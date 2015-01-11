class PocketItemView < UIScrollView
  GOOGLE_FAVICON_URL = "http://www.google.com/s2/favicons"
  SQUARE_IMAGE_SIDE = 80

  @@placeholder_favicon = UIImage.imageNamed('no_favicon')

  def self.setContent(controller, item)
    fullWidth = controller.view.bounds.size.width

    body = self.alloc.initWithFrame(controller.view.bounds)
    body.backgroundColor = UIColor.whiteColor

    # favicon
    item.url =~ %r{\Ahttps?://((\w|-|.)+?)/}
    url_domain = $1

    faviconView = UIImageView.new.tap do |v|
      v.frame = [[10, 15], [16, 16]]
      v.setImageWithURL(
        "#{GOOGLE_FAVICON_URL}?domain=#{url_domain}".url_encode.nsurl,
        placeholderImage: @@placeholder_favicon
      )
    end
    body.addSubview faviconView

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
        item.url.url_encode.nsurl,
        withRange: item.title.rangeOfString(item.title)
      )
      l.delegate = controller
    end
    body.addSubview titleLabel

    # image
    unless item.asset_src.nil?
      imageView = UIImageView.new.tap do |v|
        v.contentMode = UIViewContentModeScaleAspectFit
        v.setImageWithURL(item.asset_src.url_encode.nsurl)
        v.frame = [[fullWidth - SQUARE_IMAGE_SIDE - 10, titleLabel.bottom + 10], [SQUARE_IMAGE_SIDE, SQUARE_IMAGE_SIDE]]
      end
      body.addSubview imageView
    end

    # excerpt
    excerptLabelWidth =
      if imageView.nil?
        fullWidth - titleLabelOriginX - 10
      else
        fullWidth - titleLabelOriginX - SQUARE_IMAGE_SIDE - 10
      end
    excerptLabel = UILabel.new.tap do |l|
      l.frame = [[titleLabelOriginX, titleLabel.bottom + 10], [excerptLabelWidth, 960]]
      l.lineBreakMode = NSLineBreakByTruncatingTail
      l.text = item.excerpt
      l.font = UIFont.systemFontOfSize(14)
      l.numberOfLines = 6
      l.sizeToFit
    end
    body.addSubview excerptLabel

    # URL
    urlLabel = UILabel.new.tap do |l|
      l.frame = [[titleLabelOriginX, excerptLabel.bottom + 10], [fullWidth - titleLabelOriginX - 10, 960]]
      l.lineBreakMode = NSLineBreakByCharWrapping
      l.text = item.url
      l.textColor = UIColor.grayColor
      l.font = UIFont.systemFontOfSize(13)
      l.numberOfLines = 0
      l.sizeToFit
    end
    body.addSubview urlLabel

    # アイテムの追加日
    dateLabel = UILabel.new.tap do |l|
      l.frame = [[titleLabelOriginX, urlLabel.bottom + 5], [fullWidth - titleLabelOriginX - 10, 960]]
      l.lineBreakMode = NSLineBreakByCharWrapping
      l.text = "#{item.added_time}に追加"
      l.textColor = UIColor.grayColor
      l.font = UIFont.systemFontOfSize(13)
      l.numberOfLines = 1
      l.sizeToFit
    end
    body.addSubview dateLabel

    # 区切り線
    firstBorder = borderLine(dateLabel.bottom + 10, fullWidth)
    body.addSubview firstBorder

    # はてブ数
    bookmark_text = bookmarkDisplayText item
    @hatebuCountLabel = TTTAttributedLabel.new.tap do |l|
      l.frame = [[15, firstBorder.bottom + 10], [fullWidth - 30, 960]]
      l.numberOfLines = 1
      l.font = UIFont.systemFontOfSize(16)
      l.lineBreakMode = NSLineBreakByWordWrapping
      l.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter
      l.setText(bookmark_text, afterInheritingLabelAttributesAndConfiguringWithBlock:
        lambda{|str| return str }
      )
      l.sizeToFit
      l.linkAttributes = linkAttributes
      l.activeLinkAttributes = activeLinkAttributes
      l.addLinkToURL(
        "http://b.hatena.ne.jp/bookmarklet.touch?mode=comment&iphone_app=1&url=#{item.url.url_encode}".nsurl,
        withRange: bookmark_text.rangeOfString(bookmark_text)
      )
      l.delegate = controller
    end
    body.addSubview @hatebuCountLabel
    loadBookmarkCount(item)

    # 区切り線
    secondBorder = borderLine(@hatebuCountLabel.bottom + 10, fullWidth)
    body.addSubview secondBorder

    body.setContentSize [fullWidth, secondBorder.bottom + 100]
  end

  def self.bookmarkDisplayText(item)
    "ブックマーク数：#{item.bookmark_count}"
  end

  def self.linkAttributes
    {
      KCTUnderlineStyleAttributeName => NSNumber.numberWithInt(KCTUnderlineStyleNone),
      KCTForegroundColorAttributeName => UIColor.colorWithRed(
        0.314, green: 0.737, blue: 0.714, alpha: 1.0  # 50BCB6
      )
    }
  end

  def self.activeLinkAttributes
    {
      KCTUnderlineStyleAttributeName => NSNumber.numberWithInt(KCTUnderlineStyleNone),
      KCTForegroundColorAttributeName => UIColor.colorWithRed(
        0.929, green: 0.251, blue: 0.333, alpha: 1.0  # ED4055
      )
    }
  end

  def self.borderLine(originY, width)
    UIView.new.tap do |v|
      v.frame = [[10, originY], [width - 20, 0.5]]
      v.backgroundColor = UIColor.grayColor
    end
  end

  def self.loadBookmarkCount(item)
    if item.bookmark_count.nil?
      Dispatch::Queue.concurrent.async do
        item.getBookmarkCount do |bookmark_count, error|
          Dispatch::Queue.main.async do
            if error.nil?
              bookmark_text = bookmarkDisplayText(item)
              @hatebuCountLabel.setText(bookmark_text, afterInheritingLabelAttributesAndConfiguringWithBlock:
                lambda{|str| return str }
              )
              @hatebuCountLabel.addLinkToURL(
                "http://b.hatena.ne.jp/bookmarklet.touch?mode=comment&iphone_app=1&url=#{item.url.url_encode}".nsurl,
                withRange: bookmark_text.rangeOfString(bookmark_text)
              )
              @hatebuCountLabel.sizeToFit
            end
          end
        end
      end
    end
  end
end
