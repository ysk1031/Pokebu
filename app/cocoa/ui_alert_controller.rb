class UIAlertController
  def self.setErrorMessage(message)
    alert_controller = self.alertControllerWithTitle(
      'エラー',
      message: message,
      preferredStyle: UIAlertControllerStyleAlert
    )
    alert_action = UIAlertAction.actionWithTitle(
      'OK',
      style: UIAlertActionStyleDefault,
      handler: nil
    )
    alert_controller.addAction(alert_action)

    return alert_controller
  end

  def self.setNotice(message)
    alert_controller = self.alertControllerWithTitle(
      message,
      message: '',
      preferredStyle: UIAlertControllerStyleAlert
    )
    alert_action = UIAlertAction.actionWithTitle(
      'OK',
      style: UIAlertActionStyleDefault,
      handler: nil
    )
    alert_controller.addAction(alert_action)

    alert_controller
  end
end
