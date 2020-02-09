script_path = File.dirname(__FILE__)
$LOAD_PATH.unshift script_path + '\lib'
load  script_path + '\lib\os_ntf_elevations.rb'

net = WSApplication.current_network

nodes = {}
net.row_object_collection('_nodes').each do |ro|

  nodes[ro.id] = { "x" => ro.x,  "y" => ro.y }

end

net.transaction_begin

ntf_folder = "C:\\Ordnance Survey GIS\\NTF Heights\\10m NTF Files"
spacing = 10

elevations = OSNtfElevations.new(nodes, ntf_folder, spacing)
return_data = elevations.calculate_elevations

return_data.each do |id, node|

  ro = net.row_object('_nodes',id)
  ro['z'] = node["elevation"]
  ro['z_flag'] = 'LO'
  ro.write
end


net.transaction_commit