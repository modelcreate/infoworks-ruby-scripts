module CustomerAllocation
  module Allocator        
    def self.allocate_customer( net, cust, area_code, distance, step, max_dia)

      found_pipes = step_search(net, cust.x, cust.y, distance, step, max_dia, area_code)

      if found_pipes.nil?
        return false
      end

      closest_point = find_closest_pipe(cust.x, cust.y, found_pipes)
      update_allocation( cust, closest_point)

      return true

    end

    private

    def self.find_closest_pipe(x, y, pipes)

      closest_point = { 'distance' => Float::INFINITY }

      pipes.each.with_index do |pipe, i|
        current_distance =  Spatial::nearest_point_on_line(pipe.bends, [x,y])
        if current_distance['distance'] < closest_point['distance']
          closest_point = current_distance
          closest_point['id'] = pipe.id
          closest_point['pipe_length'] = pipe.length
        end
      end

      closest_point
    end

    def self.update_allocation(cust, closest_point )

      demand_at_us_node = closest_point["length_along"] < (closest_point["pipe_length"] / 2)

      cust.demand_at_us_node = demand_at_us_node
      cust.connection_point_x = closest_point["point"][0]
      cust.connection_point_y = closest_point["point"][1]
      cust.allocated_pipe_id = closest_point["id"]

      cust.write

    end

    def self.step_search(net, x,y, distance, steps, max_dia, area_code)

      radius = distance / steps

      steps.times do |i|
        found_pipes = net.search_at_point(x, y, radius*(i+1), 'wn_pipe')
        next if found_pipes.nil?
        filtered_pipe = found_pipes.select {|p| p.diameter < max_dia && p.area == area_code}
        next if filtered_pipe.length === 0
        return filtered_pipe

      end

      return nil
    
    end

  end
end