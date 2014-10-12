class UrlActionController < UIActivityViewController
  def initWithActivities(activity_items)
    open_in_safari = TUSafariActivity.new

    # applicationActivitiesに追加しているのに、open in safariが出ない...
    self.initWithActivityItems(
      activity_items,
      applicationActivities: [
        open_in_safari
      ]
    )
    self
  end
end
