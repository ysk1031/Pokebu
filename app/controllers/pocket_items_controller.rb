class PocketItemsController < UITableViewController
  def viewDidLoad
    super

    self.title = 'Pokebu'
    @items = []

    url = "https://getpocket.com/v3/get?consumer_key=#{ENV['POCKET_CONSUMER_KEY']}" \
      "&access_token=#{ENV['POCKET_ACCESS_TOKEN']}&count=20&offset=0&sort=newest"
    AFMotion::JSON.get(url) do |result|
      if result.success?
        @items = result.object['list'].values.sort{|a, b| a['sort_id'] <=> b['sort_id'] }
        self.tableView.reloadData
      else
        p result.error
      end
    end
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @items.count
  end

  ITEM_CELL_ID = 'Item'
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(ITEM_CELL_ID)

    if cell.nil?
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: ITEM_CELL_ID)
    end

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
end
