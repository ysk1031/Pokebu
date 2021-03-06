class PocketItemsController < UITableViewController
  READ_COUNT = 20
  CELL_HEIGHT = 75

  def viewDidLoad
    super

    self.title = 'My Pocket'

    @items = []
    @page = 0
    @last_items_size = 0

    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
    start_indicator

    @last_fetch_time = Time.now.to_i
    load_items

    self.refreshControl = UIRefreshControl.new.tap do |refresh|
      refresh.addTarget(self, action: 'refresh_items', forControlEvents: UIControlEventValueChanged)
    end

    self.tableView.addGestureRecognizer(UILongPressGestureRecognizer.alloc.initWithTarget(self, action: 'long_press_row:'))

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
      '設定', style: UIBarButtonItemStylePlain, target: self, action: 'open_setting'
    )
  end

  def load_items
    PocketItem.fetch_items(READ_COUNT, @page * READ_COUNT) do |items, error_message|
      if error_message.nil?
        @items += items
        @items.uniq!{|i| i.id }
        @last_items_size += items.count
        self.tableView.reloadData
      else
        alert_failed_request error_message
      end
      end_indicator
    end
  end

  def load_more_items
    @page += 1
    load_items
  end

  def refresh_items
    self.refreshControl.beginRefreshing

    PocketItem.fetch_items(READ_COUNT, 0, @last_fetch_time) do |items, error_message|
      if error_message.nil?
        if !items.empty? && items.first.id != @items.first.id
          new_items_count = items.count
          @items = items.concat(@items).uniq{|i| i.id }
          self.tableView.reloadData

          # スクロール位置を元の場所に
          self.tableView.setContentOffset [0, CELL_HEIGHT * new_items_count]
        end
      else
        alert_failed_request error_message
      end
    end

    @last_fetch_time = Time.now.to_i
    self.refreshControl.endRefreshing
  end

  def long_press_row(recog)
    if recog.state == UIGestureRecognizerStateBegan
      indexPath = self.tableView.indexPathForRowAtPoint(recog.locationInView(self.tableView))
      item = @items[indexPath.row]

      pocket_web_view_controller = PocketWebViewController.new.tap{|p| p.item = item }
      self.navigationController.pushViewController(pocket_web_view_controller, animated: true)
    end
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @items.count
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    CELL_HEIGHT
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    item = @items[indexPath.row]
    PocketItemCell.setItemContent(item, inTableView: tableView)
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    item = @items[indexPath.row]
    pocket_item_view_controller = PocketItemViewController.new.tap{|p| p.item = item }
    self.navigationController.pushViewController(pocket_item_view_controller, animated: true)
    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

  def scrollViewDidScroll(scrollView)
    if self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.size.height
      return if @indicator.isAnimating

      if @last_items_size >= (@page + 1) * READ_COUNT
        start_indicator
        self.performSelector('load_more_items', withObject: nil, afterDelay: 1.0)
      end
    end
  end

  def start_indicator
    @indicator.startAnimating
    @indicator.frame = [[0, 0], [self.view.frame.size.width / 2, self.view.frame.size.height / 8]]
    self.tableView.setTableFooterView @indicator
  end

  def end_indicator
    @indicator.stopAnimating
  end

  def viewWillAppear(animated)
    self.navigationController.setToolbarHidden(true, animated: true)
  end

  def viewDidAppear(animated)
    item_archive_flgs = @items.map(&:archive_flg)

    # アーカイブ操作後のみ、セルを削除
    if item_archive_flgs.include?(true)
      self.tableView.beginUpdates
      index = item_archive_flgs.index(true)

      # データソースを削除
      @items.delete_at index

      # セルを削除
      deletedPath = NSIndexPath.indexPathForRow(index, inSection: 0)
      self.tableView.deleteRowsAtIndexPaths(
        [deletedPath],
        withRowAnimation: UITableViewRowAnimationMiddle
      )
      self.tableView.endUpdates
    end
  end

  def alert_failed_request(error_message)
    alert_controller = UIAlertController.setErrorMessage error_message
    self.presentViewController(alert_controller, animated: true, completion: nil)
  end

  def open_setting
    settings_controller = SettingsController.alloc.initWithStyle(UITableViewStyleGrouped)
    setting_navi_controller = UINavigationController.alloc.initWithRootViewController(settings_controller)
    setting_navi_controller.navigationBar.translucent = false
    self.presentViewController(
      setting_navi_controller,
      animated: true,
      completion: nil
    )
  end
end
