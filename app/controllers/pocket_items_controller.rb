class PocketItemsController < UITableViewController
  READ_COUNT = 20
  ITEM_CELL_ID = 'Item'

  def viewDidLoad
    super

    self.title = 'Pokebu'
    @items = []
    @page = 0
    @last_items_size = 0

    @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
    @indicator.stopAnimating

    load_items

    self.tableView.addGestureRecognizer(UILongPressGestureRecognizer.alloc.initWithTarget(self, action: 'long_press_row:'))
  end

  def load_items
    PocketItem.fetch_items(READ_COUNT, @page * READ_COUNT) do |items, error_message|
      if error_message.nil?
        @items += items
        @last_items_size += items.size
        self.tableView.reloadData
      else
        alert = UIAlertView.new
        alert.title = 'エラー'
        alert.message = error_message
        alert.show
      end
    end
  end

  def load_more_items
    @page += 1
    load_items
    end_indicator
  end

  def long_press_row(recog)
    if recog.state == UIGestureRecognizerStateBegan
      indexPath = self.tableView.indexPathForRowAtPoint(recog.locationInView(self.tableView))
      item = @items[indexPath.row]
      p item
    end
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @items.size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(ITEM_CELL_ID) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: ITEM_CELL_ID)

    item = @items[indexPath.row]
    cell.textLabel.text = item.title
    item.url =~ %r{\Ahttps?://((\w|-|.)+?)/}
    cell.detailTextLabel.text = $1
    cell
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
end
