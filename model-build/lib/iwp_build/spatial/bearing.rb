module IwpBuild
  # Spatial Functions
  module Spatial
    def self.bearing(x1, y1, x2, y2) # rubocop:disable Naming/UncommunicativeMethodParamName, Metric/LineLength
      Math.atan2(x2 - x1, y2 - y1) * (180 / Math::PI)
    end
  end
end
