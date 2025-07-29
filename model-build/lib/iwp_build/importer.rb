module IwpBuild
  class Importer

    def initialize(network, import_folder, script_folder)
      @network = network
      @import_folder = import_folder

      cfg_location = script_folder + '\script_inc\cfg'
      callback_location = script_folder + '\script_inc\callback'

      # Define Config file locations
      @pipe_cfg = cfg_location + '\pipe.cfg'
      @reservoir_cfg = cfg_location + '\reservoir.cfg'
      @wtw_cfg = cfg_location + '\wtw.cfg'
      @hydrant_cfg = cfg_location + '\hydrant.cfg'
      @valve_node_cfg 	= cfg_location + '\valve_node.cfg'
      @twp_node_cfg 	= cfg_location + '\twp_node.cfg'
      @prv_node_cfg 	= cfg_location + '\prv_node.cfg'
      @meter_node_cfg 	= cfg_location + '\meter_node.cfg'
      @polygon_cfg 	= cfg_location + '\polygon.cfg'
      

      # Callback VBScript locations
      @pipe_cb = callback_location + '\pipe_cb.bas'
      @reservoir_cb = callback_location + '\reservoir_cb.bas'
      @wtw_cb = callback_location + '\wtw_cb.bas'
      @hydrant_cb = callback_location + '\hydrant_cb.bas'
      @valve_node_cb = callback_location + '\valve_node_cb.bas'
      @twp_node_cb = callback_location + '\twp_node_cb.bas'
      @prv_node_cb = callback_location + '\prv_node_cb.bas'
      @meter_node_cb = callback_location + '\meter_node_cb.bas'
      @polygon_cb = callback_location + '\polygon_cb.bas'
    end

    def hydrants
      options	= Hash.new
      options['Error File'] = "#{@import_folder}\\IExchange_Log.txt"
      options['Set Value Flag']	= 'IG'
      options['Duplication Behaviour']	= 'Ignore'
      options['Script File']  = @hydrant_cb
      options['Units Behaviour'] = 'Native'
      
      puts 'Hydrants: Imported all hydrants'

      @network.odic_import_ex(	'shp',
                @hydrant_cfg,	options, 'hydrant',
                @import_folder  + '\hydrant.shp')

    end

    def reservoirs
      options = Hash.new
      options['Error File'] = "#{@import_folder}\\IExchange_Log.txt"
      options['Set Value Flag']	= 'IG'
      options['Duplication Behaviour']	= 'Ignore'
      options['Script File']  = @reservoir_cb
      options['Units Behaviour'] = 'Native'

      puts 'Reservoirs: Imported all reservoirs'

      @network.odic_import_ex( 'shp', @reservoir_cfg, options, 'reservoir',
          @import_folder  + '\w_wams_asset.shp')

    end


    def wtws
      options = Hash.new
      options['Error File'] = "#{@import_folder}\\IExchange_Log.txt"
      options['Set Value Flag']	= 'IG'
      options['Duplication Behaviour']	= 'Ignore'
      options['Script File']  = @wtw_cb
      options['Units Behaviour'] = 'Native'

      puts 'WTW: Import WTW'

      @network.odic_import_ex( 'shp', @wtw_cfg, options, 'fixedhead',
          @import_folder  + '\w_wams_asset.shp')
      

    end
    

    def valves_as_nodes
      options = Hash.new
      options['Error File'] = "#{@import_folder}\\IExchange_Log.txt"
      options['Set Value Flag']	= 'IG'
      options['Duplication Behaviour']	= 'Ignore'
      options['Script File']  = @valve_node_cb
      options['Units Behaviour'] = 'Native'

      puts 'Valves: Import valve as node - done'

      @network.odic_import_ex( 'shp', @valve_node_cfg, options, 'node',
          @import_folder  + '\valve.shp')

                
    end

    def prvs_as_nodes
      options = Hash.new
      options['Error File'] = "#{@import_folder}\\IExchange_Log.txt"
      options['Set Value Flag']	= 'IG'
      options['Duplication Behaviour']	= 'Merge'
      options['Script File'] 					= @prv_node_cb
      options['Units Behaviour'] = 'Native'

      puts 'Prv: Import prv as node - done'

      @network.odic_import_ex( 'shp', @prv_node_cfg, options, 'node',
          @import_folder  + '\prv.shp')
                
    end


    def twp_as_nodes
      options = Hash.new
      options['Error File'] = "#{@import_folder}\\IExchange_Log.txt"
      options['Set Value Flag']	= 'IG'
      options['Duplication Behaviour']	= 'Ignore'
      options['Script File'] 					= @twp_node_cb
      options['Units Behaviour'] = 'Native'

      puts 'TWP: Import twp as node - done'

      @network.odic_import_ex( 'shp', @twp_node_cfg, options, 'node',
          @import_folder  + '\w_wams_asset.shp')
                
    end


    def meters_as_nodes
      options = Hash.new
      options['Error File'] = "#{@import_folder}\\IExchange_Log.txt"
      options['Set Value Flag']	= 'IG'
      options['Duplication Behaviour']	= 'Ignore'
      options['Script File'] 					= @meter_node_cb
      options['Units Behaviour'] = 'Native'

      puts 'Meters: Import meter as node'

      @network.odic_import_ex( 'shp', @meter_node_cfg, options, 'node',
          @import_folder  + '\meter.shp')

                
    end


    def pipes
      options = Hash.new
      options['Error File'] = "#{@import_folder}\\IExchange_Log.txt"
      options['Set Value Flag']	= 'IG'
      options['Duplication Behaviour']	= 'Ignore'
      options['Script File'] 					= @pipe_cb
      options['Units Behaviour'] = 'Native'

      puts 'Pipes: Import pipes'

      @network.odic_import_ex( 'shp', @pipe_cfg, options, 'pipe',
          @import_folder  + '\main_water_distribution.shp')

    end

    

    def dma_polygons
      options = Hash.new
      options['Error File'] = "#{@import_folder}\\IExchange_Log.txt"
      options['Set Value Flag']	= 'IG'
      options['Duplication Behaviour']	= 'Ignore'
      options['Script File'] 					= @polygon_cb
      options['Units Behaviour'] = 'Native'
      
      puts 'Polygons: Import DMAs - done'

      @network.odic_import_ex( 'shp', @polygon_cfg, options, 'polygons',
          @import_folder  + '\dma.shp')

                
    end
    
  end
end