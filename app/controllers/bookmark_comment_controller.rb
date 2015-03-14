class BookmarkCommentController < UITableViewController
  attr_accessor :item

  def viewDidLoad
    super

    self.title = "ブックマーク"
    self.view.backgroundColor = UIColor.whiteColor

    @bookmarks = []

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
      '閉じる', style: UIBarButtonItemStylePlain, target: self, action: 'close'
    )

    initialize_indicator
    load_bookmarks
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    bookmark = @bookmarks[indexPath.row]
    variableRect = bookmark.comment.boundingRectWithSize(
      CGSizeMake(self.view.frame.size.width - 56 - 10, CGFLOAT_MAX),
      options: NSStringDrawingUsesLineFragmentOrigin,
      attributes: { NSFontAttributeName: UIFont.systemFontOfSize(13) },
      context: nil
    )

    [variableRect.size.height + 50, 65].max
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
        @bookmarks = bookmarks
        self.tableView.reloadData
      else
        alert_controller = UIAlertController.setErrorMessage error
        self.presentViewController(alert_controller, animated: true, completion: nil)
      end
      @indicator.stopAnimating
    end
  end
end
