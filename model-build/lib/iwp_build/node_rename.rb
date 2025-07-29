module IwpBuild
  class NodeRename
    def initialize(network)
      @network = network
      @nodes_10m_square = {}
    end

    def rename
      @network.row_object_collection('_nodes').each do |ro|
        unless ro.table == 'wn_reservoir' || ro.table == 'wn_fixed_head'
          node_id_updated = xy14(ro.x, ro.y)
          update_node_list(node_id_updated, ro.node_id)
        end
      end

      @network.transaction_begin
      update_list = nodes_to_rename
      update_list.each do |node_id, updated_node_id|
        ro = @network.row_object('_nodes', node_id)
        ro.node_id = updated_node_id
        ro.write
      end
      @network.transaction_commit
    end

    def update_node_list(xy, id)
      if @nodes_10m_square.key?(xy)
        @nodes_10m_square[xy].push(id)
      else
        @nodes_10m_square[xy] = []
        @nodes_10m_square[xy].push(id)
        end
    end

    def nodes_to_rename
      rename_list = {}
      @nodes_10m_square.each do |key, square|
        if square.length == 1
          rename_list[square[0]] = key
        else
          square.each.with_index do |(node), i|
            rename_list[node] = key + '_' + (i + 1).to_s
          end
        end
      end

      rename_list
    end

    def xy14(x, y)
      x7 = '0000000' + x.to_i.to_s
      y7 = '0000000' + y.to_i.to_s
      x7[-7..-1] + y7[-7..-1]
    end
  end
end