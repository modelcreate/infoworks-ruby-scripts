require "csv"
module IwpBuild
  class ControlFile



      def initialize(network, import_folder)
        @network = network
        @import_folder = import_folder
        @controls = []


      end

      def find_control_valves

          @network.row_object_collection('wn_valve').each do |ro|

              if ro.user_text_3 == "Closed"
                  add_closed_valve(ro)
              end

              if ro.user_text_1 == "Pressure Reducing"
                  add_control_valve(ro, "PRV")
              end

              if ro.user_text_1 == "Pressure Sustaining"
                  add_control_valve(ro, "PSV")
              end

          end

      end

      def add_control_valve(valve, type)

          control_node = valve.ds_node_id

          if type == "PSV"
              control_node = valve.us_node_id
          end

          @controls.push(
              [valve.us_node_id,
              valve.ds_node_id,
              valve.link_suffix,
              valve.asset_id,
              type,"CC","","","","","999","#I",
              control_node,
              "CC"]

          )

      end

      def add_closed_valve(valve)

          @controls.push(
              [valve.us_node_id,
              valve.ds_node_id,
              valve.link_suffix,
              valve.asset_id,
              'THV','IG','0','IG','1','IG']

          )
      end

      def create

          CSV.open(@import_folder + "\\controls.csv", "wb") do |csv|
              csv << ["**** wn_ctl_valve"]
              csv << ["us_node_id","ds_node_id","link_suffix","asset_id","mode","mode_flag","opening","opening_flag","pipe_closed","pipe_closed_flag","pressure","pressure_flag","control_node","control_node_flag"]
              
              @controls.each do |control|
                  csv << control
              end
              
            end

          puts "Import controls from #{@import_folder + "\\controls.csv"}"

      end


  end
end

