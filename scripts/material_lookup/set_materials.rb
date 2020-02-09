# In the example network we have long descriptive names for materials, some of which
# are duplicates of the same material. We will use a lookup table to go from a long name
# to a short coded name which we will later use to set roughnessess
#
# The example network has the following set:
# user_text_1 - Long form material name, e.g. "Medium Density Polyethylene"
#
# Import the 'example_network.csv' file into InfoWorks WS and then run this script


# Create a custom function that takes a full material descriptor as parameter
# this function will return a short material code or nil if any information
# is missing
def get_short_material_name(material)

  material_lookup = {
    "Ductile Iron" => "DI",
    "Cast Iron" => "CI",
    "Ductile Iron Lined" => "DIL",
    "Cast Iron Lined" => "CIL",
    "Spun Iron" => "SI",
    "Steel" => "ST",
    "Asbestos Cement" => "AC",
    "Unplasticised Poly Vinyl Chloride" => "PVC",
    "PolyVinyl Chloride (Metric)" => "PVC",
    "Polyvinyl Chloride" => "PVC",
    "Polyethylene" => "PE",
    "Medium Density Polyethylene" => "PE",
    "High Density Polyethylene" => "PE",
    "High Performance Polyethylene" => "PE",
  }

  if material_lookup.key?(material)
    return material_lookup[material]
  end

  return nil
end


# Get a copy of the current open network
net = WSApplication.current_network

# Get all pipes in the network, this will be stored in an array
pipes = net.row_objects('wn_pipe')

# Before we modify any data we must open a transaction
net.transaction_begin

# Loop through each pipe in the array and lookup the short material code
# Set the pipe's material and flag the field
pipes.each do |pipe|

  # Get short material name by using the function we defined above
  mat_code = get_short_material_name(pipe.user_text_1)

  # Set the pipes material and flag if the return value isn't nil
  # run the 'write' function afterwards to save the changes locally
  unless mat_code.nil?
    pipe.material = mat_code
    pipe.material_flag = "#A"
    pipe.write
  end

end

# Commit all changes we have made to the network
net.transaction_commit
