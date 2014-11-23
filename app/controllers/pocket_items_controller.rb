class PocketItemsController < UITableViewController
  READ_COUNT = 30
  CELL_HEIGHT = 70
  ITEM_CELL_ID = 'Item'

  def viewDidLoad
    super

    self.title = 'Pokebu'
    @items = []
    @page = 0
    @last_items_size = 0

    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
    @indicator.stopAnimating
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
    cell = tableView.dequeueReusableCellWithIdentifier(ITEM_CELL_ID) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: ITEM_CELL_ID)
    item = @items[indexPath.row]

    cell.textLabel.text = item.title
    cell.textLabel.numberOfLines = 2
    cell.textLabel.font = UIFont.systemFontOfSize(16)

    item.url =~ %r{\Ahttps?://((\w|-|.)+?)/}
    cell.detailTextLabel.text = $1
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    item = @items[indexPath.row]

    if item.bookmark_count.nil?
      AFMotion::HTTP.get("http://api.b.st-hatena.com/entry.count?url=#{item.url.url_encode}") do |result|
        if result.success?
          hatebu_count = result.body.to_i
          item.bookmark_count = hatebu_count
        end
        push_pocket_item_view(item, indexPath)
      end
    else
      push_pocket_item_view(item, indexPath)
    end
  end

  def push_pocket_item_view(item, indexPath)
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

  def alert_failed_request(error_message)
    alert_controller = UIAlertController.alertControllerWithTitle(
      'エラー',
      message: error_message,
      preferredStyle: UIAlertControllerStyleAlert
    )
    alert_action = UIAlertAction.actionWithTitle(
      'OK',
      style: UIAlertActionStyleDefault,
      handler: nil
    )
    alert_controller.addAction(alert_action)
    self.presentViewController(alert_controller, animated: true, completion: nil)
  end

  def open_setting
    settings_controller = SettingsController.new
    setting_navi_controller = UINavigationController.alloc.initWithRootViewController(settings_controller)
    setting_navi_controller.navigationBar.translucent = false
    self.presentViewController(
      setting_navi_controller,
      animated: true,
      completion: nil
    )
  end
end
