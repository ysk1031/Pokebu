class BookmarkCommentController < UITableViewController
  attr_accessor :item

  def viewDidLoad
    super

    self.title = "ブックマークコメント"
    self.view.backgroundColor = UIColor.whiteColor

    @bookmarks = []

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
      '閉じる', style: UIBarButtonItemStylePlain, target: self, action: 'close'
    )

    # セルへのタップを無効に
    self.tableView.allowsSelection = false

    initialize_indicator
    load_bookmarks
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    bookmark = @bookmarks[indexPath.row]
    variableRect = bookmark.comment.boundingRectWithSize(
      CGSizeMake(self.view.frame.size.width - 100, CGFLOAT_MAX),  # コメントの表示幅より短めのwidthを指定、100は適当...
      options: NSStringDrawingUsesLineFragmentOrigin,
      attributes: { NSFontAttributeName: UIFont.systemFontOfSize(13) },
      context: nil
    )
    variableRect.size.height + 55  # 55は適当...
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    bookmark = @bookmarks[indexPath.row]
    BookmarkCommentCell.setBookmark(bookmark, inTableView: tableView)
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @bookmarks.count
  end

  def close
    self.dismissViewControllerAnimated(true, completion: nil)
  end

  def initialize_indicator
    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray).tap do |i|
      i.center           = [self.view.center.x, self.view.center.y - 100]
      i.hidesWhenStopped = true
    end
    @indicator.startAnimating
    self.view.addSubview @indicator
  end

  def load_bookmarks
    Bookmark.fetch_bookmarks(item.url) do |bookmarks, error|
      if error.nil?
        if bookmarks.count > 0
          @bookmarks = bookmarks
          self.tableView.reloadData
        else
          alert_controller = UIAlertController.setNotice('ブックマークコメントがありません')
          self.presentViewController(alert_controller, animated: true, completion: nil)
        end
      else
        alert_controller = UIAlertController.setErrorMessage error
        self.presentViewController(alert_controller, animated: true, completion: nil)
      end
      @indicator.stopAnimating
    end
  end
end
