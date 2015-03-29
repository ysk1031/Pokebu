class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    clearCache

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    initialize_pocket_sdk
    if PocketAPI.sharedAPI.loggedIn?
      pocket_items_controller = PocketItemsController.new
      navigation_controller = UINavigationController.alloc.initWithRootViewController(pocket_items_controller)
      navigation_controller.navigationBar.translucent = false
      @window.rootViewController = navigation_controller
    else
      intro_view_controller = IntroViewController.new.tap{|c| c.window = @window }
      @window.rootViewController = intro_view_controller
    end

    @window.makeKeyAndVisible
    initialize_navigation_bar

    true
  end

  def clearCache
    NSURLCache.sharedURLCache.diskCapacity = 0
    NSURLCache.sharedURLCache.memoryCapacity = 0
  end

  def initialize_navigation_bar
    UINavigationBar.appearance.barTintColor = UIColor.themeColorGreen
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
end
