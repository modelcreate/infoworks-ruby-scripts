module IwpBuild
  class ExpandNodes
    class NodeToBeExpanded
      @link_one = nil
      @link_one_ds_of_node = nil
      @link_two = nil
      @link_two_ds_of_node = nil

      def initialize(node, max_length, type, network)
        @node = node
        @max_length = max_length
        @type = type
        @network = network
        @link_count = 0

        find_links
      end

      def find_links
        @node.ds_links.each do |ds_link|
          add_link(ds_link, TRUE)
          @link_count += 1
        end

        @node.us_links.each do |us_link|
          add_link(us_link, FALSE)
          @link_count += 1
        end
      end

      def add_link(link, link_ds_of_node)
        # If there are more the two links only the first to are connected
        if @link_one.nil?
          @link_one = link
          @link_one_ds_of_node = link_ds_of_node
        elsif @link_two.nil?
          @link_two = link
          @link_two_ds_of_node = link_ds_of_node
        end
      end

      def expand
        # Check if two connected pipes are the same and zero length then this wont work
        if @link_count == 2 && @link_one.id == @link_two.id && @link_one.length == 0
          puts "ERROR: Node Expansion failed for asset id #{@node.id}, type #{@type}. US/DS link are identical with zero length "
          expand_node_on_multiple_connection
        elsif  @link_count == 2 && (@link_one.length == 0 || @link_two.length == 0)
          puts "ERROR: Node Expansion failed for asset id #{@node.id}, type #{@type}. US or DS length is zero "
          expand_node_on_multiple_connection
        elsif @link_count == 1  && @link_one.length == 0 
          puts "ERROR: Node Expansion failed for asset id #{@node.id}, type #{@type}. US or DS length is zero "
          expand_node_on_multiple_connection
        elsif @link_count > 2
          puts "ERROR: Node Expansion failed for asset id #{@node.id}, type #{@type}. More than two links connected to node"
          expand_node_on_multiple_connection
        elsif @link_count == 0
          puts "INFO: Node expanded by orientation for asset id #{@node.id}, type #{@type}."
          expand_node_on_orientation
        else
          expand_node
        end
      end

      def expand_node
        # Trim link One
        link_one_trimmed = TrimLink.new(@node.id, @link_one, @link_one_ds_of_node, 'A', @max_length / 2.0, @network)
        bends_one = link_one_trimmed.trim_link

        # trim Link Two
        if @link_count == 2
          link_two_trimmed = TrimLink.new(@node.id, @link_two, @link_two_ds_of_node, 'B', @max_length / 2.0, @network)
          bends_two = link_two_trimmed.trim_link
        else
          bends_two = extend_bends(bends_one)
          create_node("#{@node.id}_B", bends_two[-2], bends_two[-1])
        end

        # Create New Expanded Link
        merged_bends = []
        bends_one.each_slice(2).reverse_each { |a| merged_bends.push(a) }
        final_bends = merged_bends.push(bends_two.drop(2)).flatten!

        node_order = %w[A B]
        flipped_bends = []
        if @node.user_number_1.nil?
          flipped_bends = final_bends
        else
          # If angle is present check if we need to reverse
          unless direction_correct(@node.user_number_1.to_f, final_bends)
            final_bends.each_slice(2).reverse_each { |a| flipped_bends.push(a) }
            node_order = node_order.reverse
            flipped_bends = flipped_bends.flatten!
          end
        end

        id = find_pipe_id("#{@node.id}_#{node_order[0]}", "#{@node.id}_#{node_order[1]}")
        create_link(id, flipped_bends)

        @node.delete
      end

      def direction_correct(angle, bends)
        x1 = bends[0]
        y1 = bends[1]
        x2 = bends[-2]
        y2 = bends[-1]

        # Check A to B
        angleFromBends = Math.atan2(y2 - y1, x2 - x1) * (180 / Math::PI)

        if angleFromBends - angle < 180
          return false
        else
          return true
        end
      end

      def extend_bends(bends)
        # Take last two set of bends and find bearing
        x1 = bends[2]
        y1 = bends[3]
        x2 = bends[0]
        y2 = bends[1]
        # take bearing and destination from last xy
        bearing = Spatial.bearing(x1, y1, x2, y2)
        destination = Spatial.destination(x2, y2, @max_length / 2.0, bearing)

        [x2, y2, destination[0], destination[1]]
        # return two points, which is last xy and destination xy
      end

      def expand_node_on_multiple_connection

        destB = Spatial.destination(@node.x, @node.y, @max_length, 0)
        create_node("#{@node.id}_B", destB[0], destB[1])

        bends = [@node.x, @node.y, destB[0], destB[1]]

        id = find_pipe_id("#{@node.id}", "#{@node.id}_B")
        create_link(id, bends)

      end

      def expand_node_on_orientation
        bearing = @node.user_number_10
		#begin
        destA = Spatial.destination(@node.x, @node.y, @max_length / 2.0, bearing)
        destB = Spatial.destination(@node.x, @node.y, @max_length / 2.0, bearing - 180)

        create_node("#{@node.id}_A", destA[0], destA[1])
        create_node("#{@node.id}_B", destB[0], destB[1])

        bends = [destA[0], destA[1], destB[0], destB[1]]

        
        id = find_pipe_id("#{@node.id}_A", "#{@node.id}_B")
        create_link(id, bends)

        @node.delete
		#rescue
		#	puts @node
		#end
      end

      def create_node(id, x, y)
        ro = @network.new_row_object('wn_node')
        ro.id = id
        ro.x = x
        ro.y = y
        ro.write
      end

      def create_link(id, bends)
        ro = @network.new_row_object(@type)
        ro.id = id
        ro.asset_id = @node.id
        ro.asset_id_flag = 'IG'
        ro.bends = bends
        copy_attributes(ro)
        ro.write
      end

      def copy_attributes(new_link)
        %w[user_text_1 user_text_2
           user_text_3 user_text_4 user_text_5 user_text_6 user_text_7
           user_text_8 user_text_1_flag user_text_2_flag
           user_text_3_flag user_text_4_flag user_text_5_flag user_text_6_flag user_text_7_flag
           user_text_8_flag].each do |x|
          new_link[x] = @node[x]
        end


      

        if @link_count > 0 && @node['user_text_9'] == '' && @link_one['diameter'].nil? == false
          new_link['diameter'] = @link_one['diameter']
          new_link['diameter_flag'] = 'AV'
        elsif @link_count > 0 && @link_one['diameter'].nil? == false
          new_link['diameter'] = @node['user_text_9']
          new_link['diameter_flag'] = 'IG'
        end

        if @link_count > 0
          new_link['year'] = @link_one['year']
          new_link['year_flag'] = @link_one['year_flag']
          new_link['material'] = @link_one['material']
          new_link['material_flag'] = @link_one['material_flag']

        end

        if @type == 'wn_valve' 
          new_link['construction_type'] = @node['user_text_10']
          new_link['construction_type_flag'] = @node['user_text_10_flag']
        end

        type_dia_field = if @type == 'wn_non_return_valve' || @type == 'wn_valve'
                           'valve_diameter'
                         elsif @type == 'wn_meter'
                           'meter_diameter'
                         end

        unless type_dia_field.nil?
          new_link[type_dia_field] = new_link['diameter']
          new_link["#{type_dia_field}_flag"] = new_link['diameter_flag']
        end
      end


      
      #Copied from the split links, make it DRY!
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
        ro = @network.row_object('_links', id)
        ro.nil?
      end


    end
  end
end
