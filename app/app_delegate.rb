class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    initialize_hatebu_sdk

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    pocket_items_controller = PocketItemsController.new
    navigation_controller = UINavigationController.alloc.initWithRootViewController(pocket_items_controller)

    @window.rootViewController = navigation_controller
    @window.makeKeyAndVisible

    true
  end

  def initialize_hatebu_sdk
    HTBHatenaBookmarkManager.sharedManager.setConsumerKey(
      MY_ENV['hatebu']['consumer_key'],
      consumerSecret: MY_ENV['hatebu']['consumer_secret']
    )
  end
end
