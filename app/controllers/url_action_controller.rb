class UrlActionController < UIActivityViewController
  def initWithActivities(activity_items)
    self.initWithActivityItems(
      activity_items,
      applicationActivities: nil
    )
    self
  end
end
