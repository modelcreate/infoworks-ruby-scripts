# Get a copy of the current open network
net = WSApplication.current_network


# Before we modify any data we must open a transaction
net.transaction_begin

# Create the first node
node1 = net.new_row_object('wn_node')

# Update information about the node and write results
node1.id = "node1"
node1.x = 100
node1.y = 500
node1.write

# Create a second node as per the above
node2 = net.new_row_object('wn_node')
node2.id = "node2"
node2.x = 400
node2.y = 500
node2.write

# Create a pipe with a bend in it
pipe = net.new_row_object('wn_pipe')
pipe.us_node_id = "node1"
pipe.ds_node_id = "node2"
pipe.link_suffix = 1
pipe.bends = [100,500,150,400,300,600,400,500] # First two values are US Node XY, Last two are DS Node XY
pipe.write


# Commit all changes we have made to the network
net.transaction_commit