module IwpBuild
  module RenameNodes
    # Base class that individual renamers will inherit
    class Renamer
      def initialize(network)
        @network = network
        @duplicate_check = {}
      end

      # Renames all nodes within a table, if you pass '_nodes' you can
      # include an array of tables to ignore
      #
      # @param [String] name of the table to extract
      # @param [Array<String>] tables to not rename
      def rename_object_collection(table, exclude_tables = [])
        @network.row_object_collection(table).each do |ro|
          unless exclude_tables.include? ro.table
            node_id_updated = rename(ro)
            update_node_list(node_id_updated, ro.node_id)
          end
        end

        write_new_id(create_unique_ids)
      end

      private

      def rename(node)
        # takes a node and returns new name
        # this will be overwritten by each child object
      end

      def update_node_list(new_id, previous_id)
        @duplicate_check[new_id] = [] unless @duplicate_check.key?(new_id)
        @duplicate_check[new_id].push(previous_id)
      end

      def create_unique_ids
        rename_list = {}
        @duplicate_check.each do |key, square|
          if square.length == 1
            rename_list[square[0]] = key
          else
            rename_list = rename_list.merge(append_index(key, square))
          end
        end

        rename_list
      end

      def append_index(key, square)
        rename_list = {}
        square.each.with_index do |(node), i|
          rename_list[node] = key + '_' + (i + 1).to_s
        end
        rename_list
      end

      def write_new_id(nodes_to_rename)
        nodes_to_rename.each do |node_id, updated_node_id|
          ro = @network.row_object('_nodes', node_id)
          ro.node_id = updated_node_id
          ro.write
        end
      end
    end
  end
end
