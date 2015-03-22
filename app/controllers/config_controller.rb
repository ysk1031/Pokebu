class ConfigController < UITableViewController
  CONFIG_CELL_ID = "Config"

  def tableView(tableView, titleForHeaderInSection: section)
    @setting_element[section][:title]
  end

  def numberOfSectionsInTableView(tableView)
    @setting_element.count
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @setting_element[section][:cell].count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CONFIG_CELL_ID) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier: CONFIG_CELL_ID)

    cell_setting_attr         = @setting_element[indexPath.section][:cell][indexPath.row]
    cell.textLabel.text       = cell_setting_attr[:label]
    cell.detailTextLabel.text = cell_setting_attr[:detailLabel]
    cell.accessoryType        = cell_setting_attr[:accessory] unless cell_setting_attr[:accessory].nil?

    cell
  end
end
