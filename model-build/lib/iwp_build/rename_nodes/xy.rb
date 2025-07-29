module IwpBuild
  module RenameNodes
    # Renames node based on their X & Y coordinates
    class XY < Renamer
      # Creates a new XY renamer sets the amount of digits to append
      #
      # @example
      #   net = WSApplication.current_network
      #   IwpBuild::RenameNodes::XY.new(net, 14)
      #
      # @param [WSOpenNetwork] current open network
      # @param [Integer]  number of digits to the right that will be appended
      #   to the name of the node
      def initialize(network, xy_digits)
        @xy_digits = xy_digits
        @digits = '0' * (xy_digits + 1)
        super(network)
      end

      private

      def rename(node)
        x = @digits + node.x.to_i.to_s
        y = @digits + node.y.to_i.to_s
        x[-@xy_digits..-1] + y[-@xy_digits..-1]
      end
    end
  end
end
