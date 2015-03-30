class PocketItemCell < UITableViewCell
  ITEM_CELL_ID = 'Item'
  GOOGLE_FAVICON_URL = "http://www.google.com/s2/favicons"

  @@placeholder_favicon = UIImage.imageNamed('no_favicon')


  def self.setItemContent(item, inTableView: tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(ITEM_CELL_ID) ||
      self.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: ITEM_CELL_ID)
    cell.updateViewForItem item, tableView: tableView

    cell
  end

  def initWithStyle(style, reuseIdentifier: cellID)
    super(style, reuseIdentifier: cellID)

    # favicon
    @faviconView = UIImageView.new.tap{|v| v.frame = [[10, 10], [16, 16]] }
    self.contentView.addSubview @faviconView

    # タイトル
    @titleLabel = UILabel.new.tap do |l|
      l.lineBreakMode = NSLineBreakByTruncatingTail
      l.font          = UIFont.boldSystemFontOfSize(15)
    end
    self.contentView.addSubview @titleLabel

    # URL
    @urlLabel = UILabel.new.tap do |l|
      l.textColor = UIColor.grayColor
      l.font = UIFont.systemFontOfSize(13)
    end
    self.contentView.addSubview @urlLabel

    self
  end

  def updateViewForItem(item, tableView: tableView)
    item.url =~ %r{\Ahttps?://((\w|-|.)+?)/}
    url_domain = $1

    # favicon
    @faviconView.setImageWithURL(
      "#{GOOGLE_FAVICON_URL}?domain=#{url_domain}".nsurl,
      placeholderImage: @@placeholder_favicon
    )

    # タイトル
    titleLabelOriginX = @faviconView.right + 6
    @titleLabel.frame = [
      [titleLabelOriginX, 10],
      [tableView.frame.size.width - titleLabelOriginX - 5, 100]
    ]
    @titleLabel.text = item.title
    @titleLabel.numberOfLines = 2
    @titleLabel.sizeToFit

    # URL
    @urlLabel.frame = [
      [titleLabelOriginX, @titleLabel.bottom + 1],
      [tableView.frame.size.width - titleLabelOriginX - 50, 100]
    ]
    @urlLabel.text = url_domain
    @urlLabel.numberOfLines = 1
    @urlLabel.sizeToFit
  end
end
