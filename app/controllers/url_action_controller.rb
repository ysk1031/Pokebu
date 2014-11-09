class UrlActionController < UIActivityViewController
  def initWithActivities(activity_items)
    hatebu_activity = HTBHatenaBookmarkActivity.new

    self.initWithActivityItems(
      activity_items,
      applicationActivities: [hatebu_activity]
    )
    self
  end
end
