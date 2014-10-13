module Pokebu
  module Rect
    def top
      self.frame.origin.y
    end

    def bottom
      self.frame.origin.y + self.frame.size.height
    end
  end
end
