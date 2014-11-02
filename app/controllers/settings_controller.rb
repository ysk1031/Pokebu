class SettingsController < UITableViewController
  SETTING_CELL_ID = 'Setting'

  def viewDidLoad
    super

    self.title = '設定'

    @settings = Setting.initialize_in_bulk

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
      '閉じる', style: UIBarButtonItemStylePlain, target: self, action: 'close'
    )
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @settings.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    setting = @settings[indexPath.row]

    cell = tableView.dequeueReusableCellWithIdentifier(SETTING_CELL_ID) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: SETTING_CELL_ID)

    cell.textLabel.text = setting.title
    cell.textLabel.font = UIFont.systemFontOfSize(14)
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator

    cell
  end

  def close
    self.dismissViewControllerAnimated(true, completion: nil)
  end
end
