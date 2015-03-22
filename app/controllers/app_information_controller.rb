class AppInformationController < ConfigController
  def viewDidLoad
    super

    self.title = "このアプリについて"
    @setting_element = [
      {
        title: '',
        cell: [
          { label: 'バージョン', detailLabel: NSBundle.mainBundle.infoDictionary.objectForKey('CFBundleShortVersionString') }
        ]
      },
      {
        title: '情報',
        cell: [
          { label: "About", detailLabel: "", accessory: UITableViewCellAccessoryDisclosureIndicator },
          { label: "開発者のブログ", detailLabel: "", accessory: UITableViewCellAccessoryDisclosureIndicator }
        ]
      },
      {
        title: 'フィードバック',
        cell: [
          { label: "GitHub", detailLabel: "", accessory: UITableViewCellAccessoryDisclosureIndicator }
        ]
      }
    ]
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    actBasedOnCell indexPath

    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

  def actBasedOnCell(indexPath)
    case @setting_element[indexPath.section][:cell][indexPath.row][:label]
    when "About"
      open_about_page
    when "開発者のブログ"
      open_my_blog
    when "GitHub"
      open_github
    else
    end
  end

  def open_about_page

  end

  def open_my_blog
    url = "http://yusuke-aono.hatenablog.com".url_encode.nsurl
    UIApplication.sharedApplication.openURL url
  end

  def open_github
    url = "https://github.com/ysk1031/Pokebu".url_encode.nsurl
    UIApplication.sharedApplication.openURL url
  end
end