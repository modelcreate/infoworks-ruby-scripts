# Load the library of helper modules that will be used to allocate customers
# Normally in Ruby you could just use:
# require 'lib/customer_allocation'
# However I had problems with realtive paths, so this is the workaround
script_path = File.dirname(__FILE__)
$LOAD_PATH.unshift script_path + '\lib'
load  script_path + '\lib\customer_allocation.rb'

# Config varaible of the sequence we attempt to allocate a customer point
# First we search 100m over 10 steps and connect to any pipe that is 299mm or smaller
# If that didn't allocate the customer, then we search for any pipe 600mm or smaller within 20m
# Keep going down the list until we connect the customer or report that it wasn't allocated
allocation_steps = [
  {"distance" => 100, "steps" => 10, "max_dia"=> 299},
  {"distance" => 20, "steps" => 1, "max_dia"=> 600},
  {"distance" => 500, "steps" => 10, "max_dia"=> 299},
  {"distance" => 100, "steps" => 1, "max_dia"=> 600},
  {"distance" => 1000, "steps" => 10, "max_dia"=> 299},
  {"distance" => 200, "steps" => 1, "max_dia"=> 600},
  {"distance" => 1500, "steps" => 10, "max_dia"=> 299}
]

# We are benchmarking the script time, so we keep track of when the script starts
start = Time.now

# Get the current network and all polygons in it
net = WSApplication.current_network
polys = net.row_objects('wn_polygon')

# Filter polygons to only be those that are currently selected
# Return a message if not polygons were selceted
polygons = polys.select {|p| p.selected == true}
if polygons.length == 0
  WSApplication.message_box 'No polygon selected - no allocation will be performed','OK',nil,false
end

# Main loop where we work through each polygon we want to allocate customer points
polygons.each do |poly|

  # We are allocating customers inside the polygon only to pipes that have a matching area code
  # If the polygon has no area code then skip this polygon and report to the user it was skipped
  if poly.area_code == ""
    puts "Polygon: #{poly.id}, does not have an area code set - no allocation will be performed"
    next
  end

  puts "Allocating customers in #{poly.id}"

  # Find all customer points within the current polygon
  custs = poly.objects_in_polygon("wn_address_point")

  # Move to the next polygon if there are no customers to allocate
  if custs.nil?
    puts "No customer points within #{poly.id}"
    next
  end

  # Open a transaction for each zone we will allocate
  # Start to loop through each customer in polygon
  net.transaction_begin
  custs.each do |c|

    # We will keep going through the allocation sequence until we allocate a customer
    # the allocate_customer function will return true when it finds a pipe and can connect to it
    success = false
    allocation_steps.each do |al|
      next unless success == false 

      # Method is defined in ./lib/customer_allocation/allocator.rb
      success = CustomerAllocation::Allocator::allocate_customer(
        net,              # Pass the open network to module
        c,                # Current customer attempting to allocate
        poly.area_code,   # Area code we will connect to
        al["distance"],   # Max distance for this sequence
        al["steps"],      # Steps we will search outwards towards max distance
        al["max_dia"]     # Maximum pipe diameter we will connect a customer
      )
    end

    # If we go through full sequence without allocating
    # we will report back in the log saying we could not allocate
    if success == false
      puts "#{cust.id} could not be allocated"
    end

  end

  # Save all customer allocations for this zone
  net.transaction_commit

end


# Calcualte time to run script and report back to user
finish = Time.now
diff = finish - start
puts "Customer allocation finished in #{diff.round(2)} seconds"