class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    clearCache

    initialize_pocket_sdk

    if PocketAPI.sharedAPI.loggedIn?
      initialize_window
    else
      PocketAPI.sharedAPI.loginWithHandler(
        lambda do |api, error|
          initialize_window
          if error.nil?
          else
            alert_pocket_login_failure error.localizedDescription
          end
        end
      )
    end
    initialize_navigation_bar

    true
  end

  def clearCache
    NSURLCache.sharedURLCache.diskCapacity = 0
    NSURLCache.sharedURLCache.memoryCapacity = 0
  end

  def initialize_window
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @pocket_items_controller = PocketItemsController.new
    navigation_controller = UINavigationController.alloc.initWithRootViewController(@pocket_items_controller)
    navigation_controller.navigationBar.translucent = false
    @window.rootViewController = navigation_controller
    @window.makeKeyAndVisible
  end

  def initialize_navigation_bar
    UINavigationBar.appearance.barTintColor = UIColor.colorWithRed(
      0.306, green: 0.722, blue: 0.698, alpha: 1.0  # 4EB8B2
    )
    UINavigationBar.appearance.barStyle = UIBarStyleBlack
    UINavigationBar.appearance.tintColor = UIColor.whiteColor
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

  def applicationDidReceiveMemoryWarning(application)
    NSURLCache.sharedURLCache.removeAllCachedResponses  # 不要？
    clearCache
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
