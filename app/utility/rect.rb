module Pokebu
  module Rect
    def top
      self.frame.origin.y
    end

    def bottom
      self.frame.origin.y + self.frame.size.height
    end

    def left
      self.frame.origin.x
    end

    def right
      self.frame.origin.x + self.frame.size.width
    end
  end
end
