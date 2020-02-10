require 'date'
require 'FileUtils'

prefix = Time.now.to_i.to_s
script_dir = File.dirname(WSApplication.script_file) 

db = WSApplication.open

puts "Creating model group"
model_group = db.new_model_object("Catchment Group", "DemandAllocation" + prefix )

puts "Creating network and importing csv"
moGeometry = model_group.new_model_object("Geometry", "Network" + prefix)
moGeometry.csv_import(script_dir+"\\example_network.csv", nil)
moGeometry.commit "Import CSV file"

puts "Creating demand diagram group and importing ddg file"
moDDG = model_group.new_model_object("Demand Diagram Group", "Demand Diagram Group"+ prefix)
moDemandDiagram = moDDG.import_demand_diagram(script_dir+"\\example_demands.ddg")

options = {
  "allocate_demand_unallocated" => true,
  "ignore_reservoirs" => true,
  "max_dist_along_pipe_native" => 100,
  "max_dist_to_pipe_native" => 100,
  "max_distance_steps" => 10,
  "max_pipe_diameter_native" => 500,
  "use_nearest_pipe" => true
}

puts "Running Demand Allocation"

net = moGeometry.open
DemandAllocation = WSDemandAllocation.new()
DemandAllocation.network = net
DemandAllocation.demand_diagram = moDemandDiagram
DemandAllocation.options = options 
DemandAllocation.allocate()


#bool          allocate_demand_unallocated
#Bool          reallocate_demand_average
#Bool          reallocate_demand_direct
#Bool          reallocate_demand_property
#String        exclude_allocations_flag
#Bool          exclude_allocations_with_flags
#String        restrict_allocations_to_polygon
#Bool          and_pipes_between_selected_nodes
#String        only_pipes_within_polygon
#Bool          remove_demand_average
#Bool          remove_demand_direct
#Bool          remove_demand_property
#String        allocated_flag
#Bool          ignore_reservoirs
#Long          max_distance_steps
#Double        max_dist_to_pipe_native
#Double        max_dist_along_pipe_native
#Float         max_pipe_diameter_native
#Long          max_properties_per_node
#bool          node_within_cp_polygon
#Bool          only_to_nearest_node
#Bool          only_to_selected_nodes
#Bool          use_connection_points
#Bool          use_nearest_pipe
#Bool          use_smallest_pipe
#Bool          trigger_Allocate_demand_assert