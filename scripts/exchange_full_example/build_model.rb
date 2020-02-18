# Create and run a model from raw data using Infoworks Exchange.
#
# * Import raw data using the ODIC
# * Exapand short links
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
moControl = model_group.new_model_object("Control", "Ctrl_" + prefix)
moLDC = model_group.new_model_object("Wesnet Live Data", "LDC_" + prefix)

# Prompt user for a folder
shp_dir = script_path + '\source_data'
cfg_dir = script_path + '\cfg'
err_file = shp_dir + '\errors.txt'
script_file = cfg_dir + '\odic_script.bas'

layers = {
    "hydrant" => [{ "cfg" => cfg_dir + '\hydrant.cfg', "shp" => shp_dir + '\water_hydrant.shp'}],
    "valve" => [{ "cfg" => cfg_dir + '\valve.cfg', "shp" => shp_dir + '\water_valve.shp'}],
    "meter" => [{ "cfg" => cfg_dir + '\meter.cfg', "shp" => shp_dir + '\water_meter.shp'}],
    #"polygons" => { "cfg" => cfg_dir + '\polygons.cfg',  "shp" => shp_dir + '\dma.shp' },
    "pipe" => [
        { "cfg" => cfg_dir + '\pipe.cfg', "shp" => shp_dir + '\water_mains.shp' },
        { "cfg" => cfg_dir + '\hydrant_lead.cfg', "shp" => shp_dir + '\water_hydrant_leads.shp'}
    ]
    #"pipe" => { "cfg" => cfg_dir + '\hydrant_leads.cfg', "shp" => shp_dir + '\water_hydrant_leads.shp' }
}

ModelBuilder::ODIC::import_data(moGeometry, layers, script_file, err_file)

moGeometry.commit "Import with ODIC"

open_network = moGeometry.open
ModelBuilder::ExpandLinks::run(open_network)
puts "Expanded Short Links"

moGeometry.commit "Expanded Short Links"

ModelBuilder::SetElevations::run(db, open_network)
puts "Set Elevation"

moGeometry.commit "Set Elevation"


open_control = moControl.open
ModelBuilder::SetControls::run(open_network, open_control)
puts "Set Controls"

moControl.commit "Set Controls"


live_data_folder = script_dir + '\source_data\scada'
open_ldc = moLDC.open
ModelBuilder::SetLiveData::run(open_network, open_ldc, live_data_folder)
puts "Set Live Data Config"

moLDC.commit "Set Live Data Config"

