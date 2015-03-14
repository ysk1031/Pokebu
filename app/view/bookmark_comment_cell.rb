class BookmarkCommentCell < UITableViewCell
  BOOKMARK_CELL_ID = "Bookmark"

  def self.setBookmark(bookmark, inTableView: tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(BOOKMARK_CELL_ID) ||
      self.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: BOOKMARK_CELL_ID)
    cell.updateViewForBookmark bookmark

    cell
  end

  def initWithStyle(style, reuseIdentifier: cellID)
    super

    # アイコン
    @iconView = UIImageView.new.tap{|v| v.frame = [[10, 10], [40, 40]] }
    self.contentView.addSubview @iconView

    # ユーザーID
    @userIDLabel = UILabel.new.tap do |l|
      l.lineBreakMode = NSLineBreakByTruncatingTail
      l.font          = UIFont.boldSystemFontOfSize(14)
    end
    self.contentView.addSubview @userIDLabel

    # タイムスタンプ
    @addedTimeLabel = UILabel.new.tap do |l|
      l.textColor     = UIColor.grayColor
      l.textAlignment = UITextAlignmentRight
      l.font          = UIFont.systemFontOfSize(12)
    end
    self.contentView.addSubview @addedTimeLabel

    # コメント
    @commentLabel = UILabel.new.tap do |l|
      l.font = UIFont.systemFontOfSize(13)
    end
    self.contentView.addSubview @commentLabel

    self
  end

  def updateViewForBookmark(bookmark)
    # アイコン
    @iconView.setImageWithURL(
      bookmark.user_image.url_encode.nsurl,
      placeholderImage: nil
    )

    # ユーザーID
    userIDLabelOriginX = @iconView.right + 6
    @userIDLabel.frame = [
      [userIDLabelOriginX, 10],
      [self.frame.size.width - userIDLabelOriginX - 80, 100]
    ]
    @userIDLabel.text = bookmark.user_name
    @userIDLabel.numberOfLines = 1
    @userIDLabel.sizeToFit

    # タイムスタンプ
    addedTimeLabelOriginX = self.frame.size.width - 80
    @addedTimeLabel.frame = [
      [addedTimeLabelOriginX, 10],
      [75, 100]
    ]
    @addedTimeLabel.text = bookmark.added_time
    @addedTimeLabel.numberOfLines = 1
    @addedTimeLabel.sizeToFit

    # コメント
    @commentLabel.frame = [
      [userIDLabelOriginX, @userIDLabel.bottom + 3],
      [self.frame.size.width - userIDLabelOriginX - 5, 300]
    ]
    @commentLabel.text = bookmark.comment
    @commentLabel.numberOfLines = 0
    @commentLabel.sizeToFit
  end
end