module IwpBuild
  # Spatial Functions
  module Spatial
    def self.point_along_line(x1, y1, x2, y2, dist) # rubocop:disable Naming/UncommunicativeMethodParamName, Metric/LineLength
      t = dist / distance(x1, y1, x2, y2)
      x = ((1 - t) * x1) + (t * x2)
      y = (1 - t) * y1 + t * y2

      [x, y]
    end
  end
end
