class BookmarkCommentController < UITableViewController
  attr_accessor :item

  BOOKMARK_CELL_ID = "Bookmark"

  def viewDidLoad
    super

    self.title = "ブックマーク"
    self.view.backgroundColor = UIColor.whiteColor

    @bookmarks = []

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
      '閉じる', style: UIBarButtonItemStylePlain, target: self, action: 'close'
    )

    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray).tap do |i|
      i.center           = [self.view.center.x, self.view.center.y - 100]
      i.hidesWhenStopped = true
    end
    @indicator.startAnimating

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

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    bookmark = @bookmarks[indexPath.row]
    cell = tableView.dequeueReusableCellWithIdentifier(BOOKMARK_CELL_ID) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: BOOKMARK_CELL_ID)
    cell.textLabel.text = bookmark.user_name
    cell.detailTextLabel.text = bookmark.comment

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @bookmarks.count
  end

  def close
    self.dismissViewControllerAnimated(true, completion: nil)
  end
end
