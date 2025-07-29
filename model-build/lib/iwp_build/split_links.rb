module IwpBuild
  # Takes floating nodes and splits into existing pipes for connectivity
  class SplitLinks
    def initialize(network)
      @network = network
    end

    def at_node_collection(node_type)
      split_location = nil

      @network.row_object_collection(node_type).each do |ro|
        next unless ro.us_links.length == 0 && ro.ds_links.length == 0

        found = @network.search_at_point(ro.x, ro.y, 0.5, 'wn_pipe')

        next if found.nil?

        found_index = find_closest(ro, found)
        split_location = split_pipe(ro, found[found_index])
        create_pipe(ro, found[found_index], split_location) if split_location > -1
      end
    end

    def at_intersections
      @network.row_object_collection('wn_node').each do |ro|
        total_connections = ro.us_links.length + ro.ds_links.length

        next unless total_connections == 1

        found = @network.search_at_point(ro.x, ro.y, 0.1, 'wn_pipe')
        next unless found.length == 2

        found.each do |pipe|
          next if pipe.ds_node_id == ro.id || pipe.us_node_id == ro.id

          split_location = split_pipe(ro, pipe)
          create_pipe(ro, pipe, split_location) if split_location > -1
        end
      end
    end

    private

    def find_closest(node, pipes)
      return 0 if pipes.length == 1

      closest_point = { 'distance' => Float::INFINITY }

      pipes.each.with_index do |pipe, i|
        current_distance =  Spatial.nearest_point_on_line(pipe.bends, [node.x, node.y])
        current_distance['position'] = i
        if current_distance['distance'] < closest_point['distance']
          closest_point = current_distance
        end
      end

      closest_point['position']
    end

    def split_pipe(node, pipe)
      pipe.bends.each_slice(2).with_index do |(x, y), i|
        return i if x == node.x && y == node.y
      end

      nearest_pt = Spatial.nearest_point_on_line(pipe.bends, [node.x, node.y])

      # You would think you could just run .insert on pipe.bends but it doesnt look like
      # you can do that, when you attempt that IW doesn't give any issues but doesnt
      # insert the bend, work around is just to take the bends out, add the node and
      # then reinsert
      bends = pipe.bends
      bends.insert(nearest_pt['index'] * 2,
                   nearest_pt['point'][0], nearest_pt['point'][1])
      pipe.bends = bends
      pipe.write
      node.x = nearest_pt['point'][0]
      node.y = nearest_pt['point'][1]
      node.write

      nearest_pt['index']
    end

    def create_pipe(node, pipe, split_location)
      ro = @network.new_row_object('wn_pipe')
      ro.id = find_pipe_id(pipe.us_node_id, node.id)
      ro.bends = pipe.bends[0..split_location * 2 + 1]

      ro2 = @network.new_row_object('wn_pipe')

      ro2.id = find_pipe_id(node.id, pipe.ds_node_id)
      ro2.bends = pipe.bends[split_location * 2..-1]

      %w[asset_id diameter material year user_number_1 user_number_2 user_number_3
         user_number_4 user_number_5 user_number_6 user_number_7 user_number_8
         user_number_9 user_number_10 user_text_1 user_text_2 user_text_3 user_text_4
         user_text_5 user_text_6 user_text_7 user_text_8 user_text_9 user_text_10
         asset_id_flag diameter_flag material_flag year_flag user_number_1_flag
         user_number_2_flag user_number_3_flag user_number_4_flag user_number_5_flag
         user_number_6_flag user_number_7_flag user_number_8_flag user_number_9_flag
         user_number_10_flag user_text_1_flag user_text_2_flag user_text_3_flag
         user_text_4_flag user_text_5_flag user_text_6_flag user_text_7_flag
         user_text_8_flag user_text_9_flag user_text_10_flag].each do |x|
        ro[x] = pipe[x]
        ro2[x] = pipe[x]
      end

      ro.write
      ro2.write
      pipe.delete
    end

    def find_pipe_id(us_node_id, ds_node_id)
      # Now I don't remember why I added this originally but I can't think of any
      # test cases where this would be a problem so I'm just going to comment out
      # for now and when I finally run into the problem again I can uncomment
      # and then apply a test case
      #
       i = 1
       pipe_id = "#{us_node_id}.#{ds_node_id}.#{i}"
       loop do
         break if pipe_doesnt_exists(pipe_id)
      
         i += 1
         pipe_id = "#{us_node_id}.#{ds_node_id}.#{i}"
       end
      
       pipe_id

      #"#{us_node_id}.#{ds_node_id}.1"
    end

   def pipe_doesnt_exists(id)
     ro = @network.row_object('wn_pipe', id)
     ro.nil?
   end
  end
end
