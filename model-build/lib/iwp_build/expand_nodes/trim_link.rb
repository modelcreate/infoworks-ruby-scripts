module IwpBuild
  class ExpandNodes
    class TrimLink
      def initialize(id, link, ds_of_node, suffix, max_trim, network)
        @id = id
        @link = link
        @ds_of_node = ds_of_node
        @suffix = suffix
        @network = network
        @max_length = check_max_trim(max_trim)
        @removed_bends = []
        @trimed_bends = []

        extract_bends

      end

      def trim_link
        length = 0
        pipe_split = false
        last_x = nil
        last_y = nil

        @link_bends.each_slice(2).with_index do |(x, y), i|
          if i > 0
            new_distance = distance(x, y, last_x, last_y)
            length += new_distance
            end

          if length > @max_length && pipe_split == false

            target_distance = length - new_distance
            split_bends(last_x, last_y, x, y, @max_length - target_distance)
            pipe_split = true

          end
          add_bends(x, y, pipe_split)

          last_x = x
          last_y = y
        end

        update_link

        @removed_bends
      end

      def update_link
        create_node("#{@id}_#{@suffix}", @trimed_bends[0], @trimed_bends[1])
        
        @link.id = if @ds_of_node
                     "#{@id}_#{@suffix}.#{@link.ds_node_id}.1"
                   else
                     "#{@link.us_node_id}.#{@id}_#{@suffix}.1"
                end

        #debug
        update_bends =if @ds_of_node
                        @trimed_bends
                      else
                        reverse_bends(@trimed_bends)
                      end
        begin
          @link.bends = if @ds_of_node
            @trimed_bends
          else
            reverse_bends(@trimed_bends)
          end
        rescue => exception
          puts @id
          puts update_bends.class
          raise
        end
   
        

      

        @link.write
      end

      def split_bends(last_x, last_y, x, y, distance)
        end_xy = point_along_line(last_x, last_y, x, y, distance)
        add_bends(end_xy[0], end_xy[1], true)
        add_bends(end_xy[0], end_xy[1], false)
      end

      def add_bends(x, y, pipe_split)
        if pipe_split
          @trimed_bends << x << y
        else
          @removed_bends << x << y
        end
      end

      def extract_bends
        @link_bends = if @ds_of_node
                        @link.bends
                      else
                        reverse_bends(@link.bends)
        end
      end

      def create_node(id, x, y)
        ro = @network.new_row_object('wn_node')
        ro.id = id
        ro.x = x
        ro.y = y
        ro.write
      end

      def reverse_bends(bends)
        bends_reversed = []
        bends.each_slice(2).reverse_each { |a| bends_reversed.push(a) }
        bends_reversed.flatten!
      end

      def check_max_trim(length)
        if @link.length / 2.0 < length
          @link.length / 2.0
        else
          length
        end
      end

      def distance(x1, y1, x2, y2)
        Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
      end

      def point_along_line(x1, y1, x2, y2, dist)
        t = dist / distance(x1, y1, x2, y2)
        x = ((1 - t) * x1) + (t * x2)
        y = (1 - t) * y1 + t * y2

        [x, y]
      end
    end
  end
end
