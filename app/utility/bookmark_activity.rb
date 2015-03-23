module Pokebu
  module BookmarkActivity
    def bookmark
      bookmark_view_controller = HTBHatenaBookmarkViewController.new
      bookmark_view_controller.URL = item.url.nsurl
      self.presentViewController(bookmark_view_controller, animated: true, completion: nil)
    end
  end
end