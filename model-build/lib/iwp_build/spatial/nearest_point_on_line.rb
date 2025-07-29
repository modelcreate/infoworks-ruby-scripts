module IwpBuild
  # Spatial Functions
  module Spatial
    def self.nearest_point_on_line(bends, point)
      closest_point = { 'point' => [Float::INFINITY, Float::INFINITY],
                        'distance' => Float::INFINITY }
      start = nil

      bends.each_slice(2).with_index do |(x, y), i|
        if i.zero?
          start = [x, y]
          next
        end

        stop = [x, y]
        start_to_point_dist = distance(point[0], point[1], start[0], start[1])
        stop_to_point_dist = distance(point[0], point[1], stop[0], stop[1])

        height_distance = [start_to_point_dist, stop_to_point_dist].max

        direction = bearing(start[0], start[1], stop[0], stop[1])

        perpendicular_pt1 = destination(point[0], point[1],
                                        height_distance, direction + 90)
        perpendicular_pt2 = destination(point[0], point[1],
                                        height_distance, direction - 90)

        intersect = intersects([perpendicular_pt1, perpendicular_pt2],
                               [start, stop])

        intersect_pt = {}

        unless intersect.nil?
          intersect_pt['point'] = intersect
          intersect_pt['distance'] = distance(point[0], point[1],
                                              intersect[0], intersect[1])
        end

        if start_to_point_dist < closest_point['distance']
          closest_point['point'] = start
          closest_point['distance'] = start_to_point_dist
          closest_point['index'] = i
        end

        if stop_to_point_dist < closest_point['distance']
          closest_point['point'] = stop
          closest_point['distance'] = stop_to_point_dist
          closest_point['index'] = i + 1
        end

        if intersect.nil? == false && intersect_pt['distance'] < closest_point['distance']
          closest_point['point'] = intersect_pt['point']
          closest_point['distance'] = intersect_pt['distance']
          closest_point['index'] = i
        end

        start = stop
      end

      closest_point
    end
  end
end
