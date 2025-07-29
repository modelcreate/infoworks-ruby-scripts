module IwpBuild
  # Spatial Functions
  module Spatial
    def self.intersects(line_one, line_two)
      # [[x1,y1],[x2,y2]]
      x1, y1, x2, y2, x3, y3, x4, y4 = [line_one, line_two].flatten!.map(&:to_f)
      denom = ((y4 - y3) * (x2 - x1)) - ((x4 - x3) * (y2 - y1))
      nume_a = ((x4 - x3) * (y1 - y3)) - ((y4 - y3) * (x1 - x3))
      nume_b = ((x2 - x1) * (y1 - y3)) - ((y2 - y1) * (x1 - x3))

      (return nil) if denom.zero?

      u_a = nume_a / denom
      u_b = nume_b / denom

      if u_a >= 0 && u_a <= 1 && u_b >= 0 && u_b <= 1
        x = x1 + (u_a * (x2 - x1))
        y = y1 + (u_a * (y2 - y1))
        return [x, y]
      end
      nil
    end
  end
end
