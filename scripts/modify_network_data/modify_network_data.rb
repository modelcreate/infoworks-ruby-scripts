# In the example network we have a mixture of metric and imperial sizes, we will model our
# network in  metric so we will need to convert all imperial diameters.
#
# The example network has the following set:
# user_number_1 - Nominal Pipe Diamater
# user_text_1 - Unit type, either 'mm' or 'in'
#
# Import the 'example_network.csv' file into InfoWorks WS and then run this script


# Create a custom function that takes unit and diameter as parameter
# this function will return metric diameters or nil if any information
# is missing
def get_diameter(unit, diameter)

  if unit.nil? || diameter.nil?
    return nil
  end

  if unit == "in"
    return diameter * 25.4
  elsif unit == "mm"
    return diameter
  end

end


# Get a copy of the current open network
net = WSApplication.current_network

# Get all pipes in the network, this will be stored in an array
pipes = net.row_objects('wn_pipe')

# Before we modify any data we must open a transaction
net.transaction_begin

# Loop through each pipe in the array and check the unit on user_text_1
# Set the pipe's diameter and flag the field
pipes.each do |pipe|

  # Get metric diameter by using the function we defined above
  dia = get_diameter(pipe.user_text_1, pipe.user_number_1)

  # Set the pipes diameter and diameter flag if the return value isn't nil
  # run the 'write' function afterwards to save the changes locally
  unless dia.nil?
    pipe.diameter = dia
    pipe.diameter_flag = "#A"
    pipe.write
  end

end

# Commit all changes we have made to the network
net.transaction_commit

