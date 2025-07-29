class OSTileLocator
    def initialize(x,y)
        @x = x
        @y =y
        @grid =
        [['V','W','X','Y','Z'],
        ['Q','R','S','T','U'],
        ['L','M','N','O','P'],
        ['F','G','H','J','K'],
        ['A','B','C','D','E']]

    end

    def hundredKmSqTile
        # False Origin of Grid 0,0 starts at Letter S
        # offset by 1,2 on grid lookup to start on this letter
        firstLetterX = ( @x / 500000).to_i + 2
        firstLetterY = ( @y / 500000).to_i + 1

        secondLetterX = ( (@x % 500000) / 100000).to_i
        secondLetterY = ( (@y % 500000) / 100000).to_i  

        firstLetter = @grid[firstLetterY][firstLetterX]
        secondLetter = @grid[secondLetterY][secondLetterX]

        firstLetter + secondLetter
    end

    def tenKmSqTile

        firstNumber = ( (@x % 100000) / 10000 ).to_i
        secondNumber = ( (@y % 100000) / 10000 ).to_i

        tenKmSqTile = self.hundredKmSqTile + firstNumber.to_s + secondNumber.to_s

        tenKmSqTile
    end

    def tenKmqlTileForNtfGrid

        firstNumber = ( (@x % 100000) / 20000 ).to_i * 2
        secondNumber = ( (@y % 100000) / 20000 ).to_i * 2

        tenKmqlTileForNtfGrid = self.hundredKmSqTile + firstNumber.to_s + secondNumber.to_s

        return tenKmqlTileForNtfGrid

    end

    def fiveKmSqTile

        northOrSouth = if @y % 10000 > 5000
                            "N"
                        else
                            "S"
                        end

        westOrEast = if @x % 10000 > 5000
                        "E"
                     else
                        "W" 
                     end

        fiveKmSqTile = self.tenKmSqTile + northOrSouth + westOrEast

        return fiveKmSqTile

    end

    def withinGB
        if @x >= 0 && @x <=700000 &&  @y >= 0  && @y <=1300000
            return true
        else
            return false
        end
    end
end