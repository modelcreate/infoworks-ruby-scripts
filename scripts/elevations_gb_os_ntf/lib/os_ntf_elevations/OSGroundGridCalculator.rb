require 'iwp_build/os_ntf_elevations/BilinearInterpolation'

class OSGroundGridCalculator

    def initialize(tile)

        @tile = tile

        if @tile.spacing == 10
            @rowsInDtm = 501
            @modulas = 5000
        else
            @rowsInDtm = 401
            @modulas = 20000
        end

    end

    def calculate_elevation(x, y)

        if is_at_intersection(x, y)
            elevation_at_intersection(x, y)
        else
            nodes = get_closest_node_ids(x, y)
            nodes_heights = @tile.get_nodes( nodes )
            BilinearInterpolation.calc(x, y, @tile.spacing, nodes_heights)
        end

    end

    def is_at_intersection(x, y)

        if x % @tile.spacing == 0 && y % @tile.spacing == 0
            true
        else
            false
        end

    end

    def elevation_at_intersection(x,y)

        xDirection = 1 + ( ((x % @modulas)/ @tile.spacing ).to_i * @rowsInDtm)
        yDirection = ((y % @modulas)/ @tile.spacing ).to_i
        node_id = xDirection + yDirection

        @tile.get_nodes([node_id])[0]["height"]

    end

    def get_closest_node_ids(x, y)
        # NTF are always loaded with the first feature in the bottom left hand corner being 1L
        #    and then counting up by one in the Y direction for 501 nodes, it then loops to the bottom
        #    second column which is 502L

        xDirection = 1 + ((x % @modulas)/@tile.spacing).to_i * @rowsInDtm
        yDirection = ((y % @modulas)/@tile.spacing).to_i

        firstNode = xDirection + yDirection

        [ firstNode,  firstNode + 1,  firstNode + @rowsInDtm ,  firstNode + @rowsInDtm + 1   ]
    end

end