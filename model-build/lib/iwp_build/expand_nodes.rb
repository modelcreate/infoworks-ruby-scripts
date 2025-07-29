require 'iwp_build/expand_nodes/node_to_be_expanded'
require 'iwp_build/expand_nodes/trim_link'

module IwpBuild
  # Takes nodes and expands them into links
  # Useful where GIS stores valves and meters as nodes
  class ExpandNodes
    def initialize(network)
      @network = network
    end

    def node_to_link(nodes, type, max_length)
      nodes.each do |ro|
        next if ro.id == ''

        iw_type = check_for_nrv(type, ro)
        node_to_be_expanded = NodeToBeExpanded.new(ro, max_length, iw_type,  @network)
        node_to_be_expanded.expand
      end
    end


    def check_for_nrv(type, ro)
      if type == "wn_valve" && ro.user_text_1 == "RVW" 
        'wn_non_return_valve' 
      else
        type
      end
  
    end
    
  end
end
