class BilinearInterpolation

    def self.calc(x,y,grid_interval, nodes)
        result = 0.0

        nodes.each { |node| 

            width = grid_interval -   (node["x"] - x).abs
            height = grid_interval -  (node["y"] - y).abs

            area = (width.to_f * height.to_f ) / grid_interval ** 2
            result += area * node["height"]
        }

        result

    end

end