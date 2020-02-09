require 'os_ntf_elevations/OSTileLocator'
require 'os_ntf_elevations/OSGroundGrid'
require 'os_ntf_elevations/OSGroundGridCalculator'

module IwpBuild
  class OSNtfElevations

    def initialize(nodes, ntf_folder, spacing)
      @nodes = nodes
      @ntf_folder = ntf_folder
      @spacing = spacing

      allocate_nodes
    end

    def calculate_elevations

      results = {}
      #loop through each dictionary and return a list of nodes with elevations
      @sorted_nodes.each do |key, nodes| 


        begin
          
          if @spacing == 50
            ground_grid = OSGroundGrid.new("#{@ntf_folder}\\#{key}.ntf", @spacing)
          else
            ground_grid = OSGroundGrid.new("#{@ntf_folder}\\#{key[0..1]}\\#{key}.ntf", @spacing)
          end
          
          ggc = OSGroundGridCalculator.new(ground_grid)
          nodes.each do |key, node| 
            
            node["elevation"] = ggc.calculate_elevation(node["x"], node["y"])
            results[key] = node
          end

        rescue => exception
          
          puts exception

        end

      end
      
      results
    end

    def allocate_nodes
      #Split nodes into dictionaries of grids

      @sorted_nodes = {}
      @nodes.each do |key, node| 
        if @spacing == 50
          tile = OSTileLocator.new( node["x"], node["y"] ).tenKmqlTileForNtfGrid()
        else
          tile = OSTileLocator.new( node["x"], node["y"] ).fiveKmSqTile()
        end
          @sorted_nodes[tile] ||= {}
        @sorted_nodes[tile][key] = node
      end

    end



  end
end