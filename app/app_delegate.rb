class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    initialize_pocket_sdk

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @pocket_items_controller = PocketItemsController.new
    navigation_controller = UINavigationController.alloc.initWithRootViewController(@pocket_items_controller)
    navigation_controller.navigationBar.translucent = false
    @window.rootViewController = navigation_controller

    unless PocketAPI.sharedAPI.loggedIn?
      PocketAPI.sharedAPI.loginWithHandler(
        lambda do |api, error|
          if error.nil?
          else
            alert_pocket_login_failure error.localizedDescription
          end
        end
      )
    end

    @window.makeKeyAndVisible
    return true
  end

  def initialize_hatebu_sdk
    HTBHatenaBookmarkManager.sharedManager.setConsumerKey(
      MY_ENV['hatebu']['consumer_key'],
      consumerSecret: MY_ENV['hatebu']['consumer_secret']
    )
  end

  def initialize_pocket_sdk
    PocketAPI.sharedAPI.setConsumerKey MY_ENV['pocket']['consumer_key']
  end

  def application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    true if PocketAPI.sharedAPI.handleOpenURL(url)
  end

  def applicationDidBecomeActive(application)
    initialize_hatebu_sdk
  end

  def alert_pocket_login_failure(error_message)
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
    @pocket_items_controller.presentViewController(alert_controller, animated: true, completion: nil)
  end
end
