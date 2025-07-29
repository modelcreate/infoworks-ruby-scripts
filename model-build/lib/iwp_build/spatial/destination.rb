module IwpBuild
  # Spatial Functions
  module Spatial
    def self.destination(x1, y1, distance, angle = 0) # rubocop:disable Naming/UncommunicativeMethodParamName, Metric/LineLength
      radians = angle * Math::PI / 180

      x2 = x1 + distance * Math.sin(radians)
      y2 = y1 + distance * Math.cos(radians)

      [x2, y2]
    end
  end
end
