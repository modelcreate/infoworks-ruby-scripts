script_path = File.dirname(__FILE__)
$LOAD_PATH.unshift script_path + '\lib'
load  script_path + '\lib\iwp_build.rb'


def create_model(import_folder, script_path)

  net = WSApplication.current_network

  importer = IwpBuild::Importer.new(net, import_folder, script_path)

  importer.hydrants()
  importer.reservoirs()
  importer.wtws()
  valves = importer.valves_as_nodes()
  prv = importer.prvs_as_nodes()
  meters = importer.meters_as_nodes()
  twp = importer.twp_as_nodes()
  importer.pipes()
  importer.dma_polygons()




  split_links = IwpBuild::SplitLinks.new(net)
  net.transaction_begin

  ['wn_hydrant','wn_node'].each { |type|
    split_links.at_node_collection(type)
  }
  split_links.at_intersections

  net.transaction_commit


  expand_nodes = IwpBuild::ExpandNodes.new(net)
  net.transaction_begin
  
  expand_nodes.node_to_link(valves, 'wn_valve', 1.0)
  expand_nodes.node_to_link(meters, 'wn_meter', 1.0)
  expand_nodes.node_to_link(prv, 'wn_valve', 1.0)
  expand_nodes.node_to_link(twp, 'wn_pst', 1.0)
  
  net.transaction_commit


  IwpBuild::NodeRename.new(net).rename


  puts 'Setting Roughness'
  roughness = IwpBuild::Roughness.new(net)
  roughness.set_roughness


  
  puts 'Elevations'
      
  nodes = {}
  net.row_object_collection('_nodes').each do |ro|

    nodes[ro.id] = { "x" => ro.x,  "y" => ro.y }

  end
  net.transaction_begin

  ntf_folder= script_path + '\Ordnance Survey 10m NTF Files'
  spacing = 10

  elevations = IwpBuild::OSNtfElevations.new(nodes, ntf_folder, spacing)
  return_data = elevations.calculate_elevations

  return_data.each do |id, node|

    ro=net.row_object('_nodes',id)
    ro['z'] = node["elevation"]
    ro['z_flag'] = 'LO'
    ro.write
  end


  net.transaction_commit


  control_file = IwpBuild::ControlFile.new(net, import_folder)
  control_file.find_control_valves
  control_file.create


end


# Prompt the user to select a folder containing the shapefiles
import_folder = WSApplication.folder_dialog('Select folder containing import files', true)

if import_folder.nil?
  puts 'No folder selected - no import will be performed.'
else

  create_model(import_folder, script_path)
end

