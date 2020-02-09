# Class opens the NTF files and returns nodes based on their ids

class OSGroundGrid
  attr_reader :spacing

  def initialize(tile_location, spacing)
    @tile_location = tile_location
    @spacing = spacing

    load_nodes

  end

  def find_start_coords(header_record)
    #Read Section Header Record 
    @start_x = header_record[46..55].to_i
    @start_y = header_record[56..65].to_i
  end

  def load_nodes
    @nodes = {}

    reading_header = true
    skip_lines =  0
    index = 1
    column = 0
    row = 0

    divider = if @spacing == 10
                10
              else
                1
              end

    File.foreach(@tile_location) { |line| 
      if reading_header
        if line[0..1] == "07"
          find_start_coords(line)
          next
        elsif line[0..1] == "51" && @spacing == 50
          skip_lines = 1
          reading_header = false
          next
        elsif line[0..1] == "51" && @spacing == 10
          reading_header = false
        else
          next
        end
      end

      unless skip_lines == 0
        skip_lines -=1
        next
      end

      if (line[0..1] == "51" && @spacing == 50) || line[0..1] == "99" 
        skip_lines = 1
        next
      elsif line[0..1] == "51" && @spacing == 10
        split = line[18..-4].scan(/...../)
      else
        if @spacing == 10
          split = line[2..-4].scan(/...../)
        else
          split = line[2..-4].scan(/..../)
        end
      end


      split.each do |value|
        @nodes[index] = {
          "x" => @start_x + column * @spacing,
          "y" => @start_y + row * @spacing,
          "height"  => value.to_f/divider
        }
        index += 1
        row += 1
      end
      
      if line[-3..-2] == '0%'
        row = 0
        column += 1
      end

    }

  end

  def get_nodes(nodes)
    return_nodes = []

    nodes.each { |node_id|
      return_nodes.push(@nodes[node_id])
    }

    return_nodes
  end


end