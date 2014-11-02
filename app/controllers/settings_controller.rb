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

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    setting = @settings[indexPath.row]
    case setting.action
    when 'hatebu'
      hatebu_auth
    else

    end
    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

  def hatebu_auth
    if HTBHatenaBookmarkManager.sharedManager.authorized
      hatebu_config_controller = HatebuConfigController.new
      self.navigationController.pushViewController(hatebu_config_controller, animated: true)
    else
      NSNotificationCenter.defaultCenter.addObserver(
        self,
        selector: 'showHatebuOAuthLoginView:',
        name: KHTBLoginStartNotification,
        object: nil
      )
      HTBHatenaBookmarkManager.sharedManager.authorizeWithSuccess(
        lambda { @hatebu_navi_controller.dismissViewControllerAnimated(true, completion: nil) },
        failure: lambda {|error| p error }
      )
    end
  end

  def showHatebuOAuthLoginView(notification)
    NSNotificationCenter.defaultCenter.removeObserver(self, name: KHTBLoginStartNotification, object: nil)
    req = notification.object
    @hatebu_navi_controller = UINavigationController.alloc.initWithNavigationBarClass(HTBNavigationBar, toolbarClass: nil)
    @hatebu_navi_controller.navigationBar.translucent = false
    hatebu_login_view_controller = HTBLoginWebViewController.alloc.initWithAuthorizationRequest(req)
    @hatebu_navi_controller.viewControllers = [hatebu_login_view_controller]
    self.presentViewController(@hatebu_navi_controller, animated: true, completion: nil)
  end

  def close
    self.dismissViewControllerAnimated(true, completion: nil)
  end
end
