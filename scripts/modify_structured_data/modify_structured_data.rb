# Get a copy of the current open network
net = WSApplication.current_network


# Before we modify any data we must open a transaction
net.transaction_begin


# Create a simple tank
tank = net.new_row_object('wn_reservoir')
tank.x = 0
tank.y = 0
tank.id = "tank"

# Set the length of the structured data
tank.depth_volume.length = 2

# You can now access the rows and set data within the structured data
row1 = tank.depth_volume[0]
row1.depth = 1
row1.volume = 1000

row2 = tank.depth_volume[1]
row2.depth = 2
row2.volume = 3000

# Write both the WSStructure and then the network object
tank.depth_volume.write
tank.write


# Commit all changes we have made to the network
net.transaction_commit