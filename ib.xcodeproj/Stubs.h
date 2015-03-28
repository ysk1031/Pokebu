// Generated by IB v0.7.2 gem. Do not edit it manually
// Run `rake ib:open` to refresh

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import <Security/Security.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface AppDelegate: UIResponder <UIApplicationDelegate>
-(IBAction) clearCache;
-(IBAction) initialize_window;
-(IBAction) initialize_navigation_bar;
-(IBAction) initialize_hatebu_sdk;
-(IBAction) initialize_pocket_sdk;
-(IBAction) applicationDidBecomeActive:(id) application;
-(IBAction) applicationDidReceiveMemoryWarning:(id) application;
-(IBAction) alert_pocket_login_failure:(id) error_message;

@end

@interface NSString: NSObject
-(IBAction) url_encode;
-(IBAction) nsurl;

@end

@interface UIAlertController: NSObject
@end

@interface UIColor: NSObject
@end

@interface UIView: NSObject
@end

@interface AboutAppController: UIViewController
-(IBAction) viewDidLoad;
-(IBAction) documentHTMLForAbout;

@end

@interface ConfigController: UITableViewController
-(IBAction) numberOfSectionsInTableView:(id) tableView;

@end

@interface AppInformationController: ConfigController
-(IBAction) viewDidLoad;
-(IBAction) actBasedOnCell:(id) indexPath;
-(IBAction) open_about_page;
-(IBAction) open_my_blog;
-(IBAction) open_github;

@end

@interface BookmarkCommentController: UITableViewController
-(IBAction) viewDidLoad;
-(IBAction) close;
-(IBAction) initialize_indicator;
-(IBAction) load_bookmarks;

@end

@interface HatebuConfigController: ConfigController
-(IBAction) viewDidLoad;

@end

@interface PocketConfigController: ConfigController
-(IBAction) viewDidLoad;

@end

@interface PocketItemViewController: UIViewController
-(IBAction) viewDidLoad;
-(IBAction) setToolbar;
-(IBAction) do_action;
-(IBAction) load_bookmarks;

@end

@interface PocketItemsController: UITableViewController
-(IBAction) viewDidLoad;
-(IBAction) load_items;
-(IBAction) load_more_items;
-(IBAction) refresh_items;
-(IBAction) long_press_row:(id) recog;
-(IBAction) scrollViewDidScroll:(id) scrollView;
-(IBAction) start_indicator;
-(IBAction) end_indicator;
-(IBAction) viewWillAppear:(id) animated;
-(IBAction) viewDidAppear:(id) animated;
-(IBAction) alert_failed_request:(id) error_message;
-(IBAction) open_setting;

@end

@interface PocketWebViewController: UIViewController
-(IBAction) viewDidLoad;
-(IBAction) setToolbar;
-(IBAction) setIndicator;
-(IBAction) go_back;
-(IBAction) reload;
-(IBAction) do_action;
-(IBAction) webViewDidFinishLoad:(id) webView;
-(IBAction) didReceiveMemoryWarning;

@end

@interface SettingsController: UITableViewController
-(IBAction) viewDidLoad;
-(IBAction) numberOfSectionsInTableView:(id) tableView;
-(IBAction) pocket_auth;
-(IBAction) hatebu_auth;
-(IBAction) showHatebuOAuthLoginView:(id) notification;
-(IBAction) app_information;
-(IBAction) close;

@end

@interface UrlActionController: UIActivityViewController
-(IBAction) initWithActivities:(id) activity_items;

@end

@interface Bookmark: NSObject
-(IBAction) initialize:(id) data;
-(IBAction) added_time;

@end

@interface PocketItem: NSObject
-(IBAction) initialize:(id) data;
-(IBAction) added_time;

@end

@interface Setting: NSObject
-(IBAction) initialize:(id) info;

@end

@interface BookmarkCommentCell: UITableViewCell
-(IBAction) updateViewForBookmark:(id) bookmark;

@end

@interface PocketItemCell: UITableViewCell
-(IBAction) updateViewForItem:(id) item;

@end

@interface PocketItemView: UIScrollView
-(IBAction) bookmarkDisplayText:(id) item;
-(IBAction) linkAttributes;
-(IBAction) activeLinkAttributes;
-(IBAction) loadBookmarkCount:(id) item;

@end

