# Turf.js methods intersects & nearest_point_on_line 
# converted from JavaScript to Ruby
# https://turfjs.org/
# https://github.com/Turfjs/turf

module CustomerAllocation
  module Spatial
    def self.intersects(line_one, line_two)
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

    def self.distance(x1, y1, x2, y2)
      Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
    end

    def self.bearing(x1, y1, x2, y2)
      Math.atan2(x2 - x1, y2 - y1) * (180 / Math::PI)
    end


    def self.destination(x1, y1, distance, angle = 0)
      radians = angle * Math::PI / 180

      x2 = x1 + distance * Math.sin(radians)
      y2 = y1 + distance * Math.cos(radians)

      [x2, y2]
    end

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

      closest_point["length_along"] = along_length(closest_point['point'],  closest_point['index'], bends)
      closest_point
    end

    def self.along_length(point, index, bends)

      start = nil
      length = 0

      bends.each_slice(2).with_index do |(x, y), i|
        if i.zero?
          start = [x, y]
          next
        end

        stop = [x, y]


        if i == index
          start_to_point_dist = distance(point[0], point[1], start[0], start[1])
          return length + start_to_point_dist
        end

        segment_dist = distance(start[0], start[1], stop[0], stop[1])
        length = length + segment_dist

        start = stop

      end

      return length

    end
  end
end