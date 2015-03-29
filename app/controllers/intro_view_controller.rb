class IntroViewController < UIViewController
  attr_accessor :window

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.themeColorGreen

    fullWidth  = self.view.bounds.size.width

    @appName = UILabel.new.tap do |l|
      l.frame         = [[50, 70], [fullWidth - 100, 100]]
      l.numberOfLines = 1
      l.textAlignment = UITextAlignmentCenter
      l.text          = "PokeBu"
      l.font          = UIFont.fontWithName("Avenir Next", size: 48)
      l.textColor     = UIColor.themeColorGreen
    end
    self.view.addSubview @appName

    @appDescription = UILabel.new.tap do |l|
      l.frame         = [[30, @appName.bottom + 20], [fullWidth - 60, 100]]
      l.numberOfLines = 0
      l.text          = "Pocketに保存したアイテムのリーダーです。\n\n" \
        "保存してある未読記事を消化・アーカイブしながら、" \
        "はてなブックマークのコメントを閲覧したり、ブックマーク追加したりできます。"
      l.font          = UIFont.systemFontOfSize(20)
      l.textColor     = UIColor.themeColorGreen
      l.sizeToFit
    end
    self.view.addSubview @appDescription

    @pocketLoginButton = UIButton.buttonWithType(UIButtonTypeSystem).tap do |b|
      b.frame                      = [[50, @appDescription.bottom + 25], [fullWidth - 100, 100]]
      b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter
      b.titleLabel.font            = UIFont.boldSystemFontOfSize(24)
      b.setTitle("Pocketでログイン", forState: UIControlStateNormal)
      b.setTitleColor(UIColor.themeColorGreen, forState: UIControlStateNormal)
    end
    self.view.addSubview @pocketLoginButton
  end

  def viewDidAppear(animated)
    animation = CATransition.animation
    animation.setType KCATransitionFade
    animation.setDuration 0.7
    @appName.layer.addAnimation(animation, forKey: nil)
    @appName.textColor = UIColor.whiteColor

    @appDescription.layer.addAnimation(animation, forKey: nil)
    @appDescription.textColor = UIColor.whiteColor

    @pocketLoginButton.layer.addAnimation(animation, forKey: nil)
    @pocketLoginButton.setTitleColor(UIColor.whiteColor, forState: UIControlStateNormal)

    @pocketLoginButton.addTarget(self, action: "pocket_login", forControlEvents: UIControlEventTouchUpInside)
  end

  def pocket_login
    PocketAPI.sharedAPI.loginWithHandler(
      lambda do |api, error|
        if error.nil?
          @pocket_items_controller = PocketItemsController.new
          navigation_controller = UINavigationController.alloc.initWithRootViewController(@pocket_items_controller)
          navigation_controller.navigationBar.translucent = false

          window.rootViewController = navigation_controller
        else
          alert_pocket_login_failure error.localizedDescription
        end
      end
    )
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