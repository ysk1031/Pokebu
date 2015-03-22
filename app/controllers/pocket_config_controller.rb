class PocketConfigController < ConfigController
  def viewDidLoad
    super
    self.title = 'サービス連携'
    @setting_element = [
      {
        title: 'Pocketアカウント',
        cell: [
          {
            label: '連携を解除',
            detailLabel: PocketAPI.sharedAPI.username
          }
        ]
      }
    ]
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    alert_controller = UIAlertController.alertControllerWithTitle(
      '確認',
      message: 'Pocketからログアウトしてもよろしいですか？',
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
        PocketAPI.sharedAPI.logout
        self.navigationController.popViewControllerAnimated(true)
      end
    )
    alert_controller.addAction(cancel)
    alert_controller.addAction(ok)
    self.presentViewController(alert_controller, animated: true, completion: nil)
    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end
end
