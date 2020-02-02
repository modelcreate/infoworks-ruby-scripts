require 'FileUtils'

open_net = WSApplication.current_network

# Prompt user for a folder
shp_dir = WSApplication.folder_dialog 'Select a folder to import files',  true 

# We keep our CFG files with the Ruby script
cfg_dir = File.dirname(WSApplication.script_file) 

err_file = shp_dir + '\errors.txt'
script_file = cfg_dir + '\odic_script.bas'

layers = {
    "hydrant" => { "cfg" => cfg_dir + '\hydrant.cfg', "shp" => shp_dir + '\hydrants.shp'},
    "valve" => { "cfg" => cfg_dir + '\valve.cfg', "shp" => shp_dir + '\valves.shp'},
    "polygons" => { "cfg" => cfg_dir + '\polygons.cfg',  "shp" => shp_dir + '\dma.shp' },
    "pipe" => { "cfg" => cfg_dir + '\pipe.cfg', "shp" => shp_dir + '\mains.shp' }
}

layers.each do | layer, config |

    puts "Importing IW layer: #{layer}"

    # If the file to import doesnt exist then skip over it
    if File.exist?( config["shp"] ) == false
        puts "Shape file not found for #{layer} layer - #{config["shp"]}"
        next
    end

    options = {
        "Error File" => err_file,    # Save error log path
        "Set Value Flag" => 'IG',    # Import Flag
        "Script File"=> script_file  # Import Script (ICM .rb / WS .bas)
    }
    
    open_net.odic_import_ex(
        'shp',            # Date Source: Source Type
        config["cfg"],    # Field Mapping Configuration
        options,          # Additional options in Ruby Hash
        layer,            # InfoWorks Layer to Import
        config["shp"]     # Shape file location
    )

    # Append the error file with layer completed
    File.write(err_file, "\n End of #{layer} import \n", File.size(err_file))


end
                                                                            
# Open the error log and output to console
File.readlines(err_file).each do |line|
    puts line
end

puts "Finished Import"