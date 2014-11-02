class HatebuConfigController < UITableViewController
  CONFIG_CELL_ID = "Config"

  def viewDidLoad
    super

    self.title = '設定'
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, titleForHeaderInSection: section)
    'はてなブックマーク'
  end

  def tableView(tableView, numberOfRowsInSection: section)
    1
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CONFIG_CELL_ID) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier: CONFIG_CELL_ID)
    cell.textLabel.text = '連携を解除'
    cell.detailTextLabel.text = HTBHatenaBookmarkManager.sharedManager.username

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    alert_controller = UIAlertController.alertControllerWithTitle(
      '確認',
      message: 'はてなブックマークの連携を解除してもよろしいですか？',
      preferredStyle: UIAlertControllerStyleAlert
    )
    cancel = UIAlertAction.actionWithTitle(
      'キャンセル',
      style: UIAlertActionStyleDefault,
      handler: nil
    )
    ok = UIAlertAction.actionWithTitle(
      'OK',
      style: UIAlertActionStyleDefault,
      handler: lambda do |action|
        HTBHatenaBookmarkManager.sharedManager.logout
        self.navigationController.popViewControllerAnimated(true)
      end
    )
    alert_controller.addAction(cancel)
    alert_controller.addAction(ok)
    self.presentViewController(alert_controller, animated: true, completion: nil)
    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end
end
