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

    url = "https://getpocket.com/v3/get?consumer_key=#{ENV['POCKET_CONSUMER_KEY']}" \
      "&access_token=#{ENV['POCKET_ACCESS_TOKEN']}&count=#{READ_COUNT}&offset=#{@page * READ_COUNT}&sort=newest"
    AFMotion::JSON.get(url) do |result|
      if result.success?
        @items = result.object['list'].values.sort{|a, b| a['sort_id'] <=> b['sort_id'] }
        @last_items_size += @items.size
        self.tableView.reloadData
      else
        p result.error
      end
    end
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @items.size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(ITEM_CELL_ID) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: ITEM_CELL_ID)

    item = @items[indexPath.row]
    cell.textLabel.text =
      if item['resolved_title'].empty?
        item['given_title']
      else
        item['resolved_title']
      end

    item['resolved_url'] =~ %r{\Ahttps?://((\w|-|.)+?)/}
    cell.detailTextLabel.text = $1
    cell
  end

  def scrollViewDidScroll(scrollView)
    if self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.size.height
      return if @indicator.isAnimating

      if @last_items_size >= (@page + 1) * READ_COUNT
        @indicator.startAnimating
        @indicator.frame.size.height += 10.0
        self.tableView.setTableFooterView @indicator

        @page += 1
        url = "https://getpocket.com/v3/get?consumer_key=#{ENV['POCKET_CONSUMER_KEY']}" \
          "&access_token=#{ENV['POCKET_ACCESS_TOKEN']}&count=#{READ_COUNT}&offset=#{@page * READ_COUNT}&sort=newest"
        AFMotion::JSON.get(url) do |result|
          if result.success?
            obtained_items = result.object['list'].values.sort{|a, b| a['sort_id'] <=> b['sort_id'] }
            @items += obtained_items
            @last_items_size += obtained_items.size
            self.tableView.reloadData
          else
            p result.error
          end
        end
        @indicator.stopAnimating
      end
    end
  end
end
