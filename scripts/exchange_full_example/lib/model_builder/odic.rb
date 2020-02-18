require 'FileUtils'

module ModelBuilder
  module ODIC
    def self.import_data(open_net, layers, script_file, err_file)
        
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

    end
  end
end
  


