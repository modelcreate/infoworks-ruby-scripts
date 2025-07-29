module IwpBuild
  # Spatial Functions
  module Spatial
    def self.distance(x1, y1, x2, y2) # rubocop:disable Naming/UncommunicativeMethodParamName, Metric/LineLength
      Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
    end
  end
end
