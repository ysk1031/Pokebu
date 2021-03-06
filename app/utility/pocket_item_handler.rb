module Pokebu
  module PocketItemHandler
    def alertArchive
      alert_controller = UIAlertController.alertControllerWithTitle(
        '確認',
        message: 'この記事をアーカイブしますか？',
        preferredStyle: UIAlertControllerStyleActionSheet
      )
      cancel = UIAlertAction.actionWithTitle(
        'キャンセル',
        style: UIAlertActionStyleCancel,
        handler: nil
      )
      ok = UIAlertAction.actionWithTitle(
        'OK',
        style: UIAlertActionStyleDefault,
        handler: lambda do |action|
          runArchive
        end
      )
      alert_controller.addAction(ok)
      alert_controller.addAction(cancel)
      self.presentViewController(alert_controller, animated: true, completion: nil)
    end

    def runArchive
      item.archive do |result, error|
        if result
          item.archive_flg = true
          self.navigationController.popToRootViewControllerAnimated(true)
        else
          alert_controller = UIAlertController.setErrorMessage error
          self.presentViewController(alert_controller, animated: true, completion: nil)
        end
      end
    end
  end
end
