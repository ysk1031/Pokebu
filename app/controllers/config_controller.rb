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
    cell.textLabel.text = @setting_element[indexPath.section][:cell][indexPath.row][:label]
    cell.detailTextLabel.text = @setting_element[indexPath.section][:cell][indexPath.row][:detailLabel]
    cell
  end
end
