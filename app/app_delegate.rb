class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    pocket_items_controller = PocketItemsController.new
    navigation_controller = UINavigationController.alloc.initWithRootViewController(pocket_items_controller)

    @window.rootViewController = navigation_controller
    @window.makeKeyAndVisible

    true
  end
end
