# Create and run a model from raw data using Infoworks Exchange.
#
# * Import raw data using the ODIC
# * Set elevations
# * Create controls
# * Create live data config
# * Create ddg
# * Validate model
# * Create run
# * Run simulation

require 'date'
require 'FileUtils'

script_path = File.dirname(__FILE__)
$LOAD_PATH.unshift script_path + '\lib'
load  script_path + '\lib\model_builder.rb'

prefix = Time.now.to_i.to_s
script_dir = File.dirname(WSApplication.script_file) 

db = WSApplication.open

puts "Creating model group"
model_group = db.new_model_object("Catchment Group", "ModelBuild_" + prefix )

puts "Creating network and import using ODIC"
moGeometry = model_group.new_model_object("Geometry", "Network_" + prefix)


# Prompt user for a folder
shp_dir = script_path + '\source_data'
cfg_dir = script_path + '\cfg'
err_file = shp_dir + '\errors.txt'
script_file = cfg_dir + '\odic_script.bas'

layers = {
    "hydrant" => { "cfg" => cfg_dir + '\hydrant.cfg', "shp" => shp_dir + '\water_hydrant.shp'},
    #"valve" => { "cfg" => cfg_dir + '\valve.cfg', "shp" => shp_dir + '\valves.shp'},
    #"polygons" => { "cfg" => cfg_dir + '\polygons.cfg',  "shp" => shp_dir + '\dma.shp' },
    #"pipe" => { "cfg" => cfg_dir + '\pipe.cfg', "shp" => shp_dir + '\mains.shp' }
}

ModelBuilder::ODIC::import_data(moGeometry, layers, script_file, err_file)

moGeometry.commit "Import with ODIC"




#puts "Creating demand diagram group and importing ddg file"
#moDDG = model_group.new_model_object("Demand Diagram Group", "Demand Diagram Group"+ prefix)
#moDemandDiagram = moDDG.import_demand_diagram(script_dir+"\\example_demands.ddg")
#
#options = {
#  "allocate_demand_unallocated" => true,
#  "ignore_reservoirs" => true,
#  "max_dist_along_pipe_native" => 100,
#  "max_dist_to_pipe_native" => 100,
#  "max_distance_steps" => 10,
#  "max_pipe_diameter_native" => 500,
#  "use_nearest_pipe" => true
#}
#
#puts "Running Demand Allocation"
#
#net = moGeometry.open
#DemandAllocation = WSDemandAllocation.new()
#DemandAllocation.network = net
#DemandAllocation.demand_diagram = moDemandDiagram
#DemandAllocation.options = options 
#DemandAllocation.allocate()


