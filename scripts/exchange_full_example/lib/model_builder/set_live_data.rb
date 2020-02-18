require 'FileUtils'

module ModelBuilder
    module SetLiveData
  
      def self.run(open_net, open_ldc, live_data_folder)
        live_meters = open_net.row_objects('wn_meter').select {|v| v.billing_id.nil? == false}
  
        open_ldc.transaction_begin
  
        live_meters.each {|m| create_live_data_point(m, open_ldc,live_data_folder) }
  
        open_ldc.transaction_commit
  
      end
  
      private

      def self.double_dash(path, file, extension)

        return File.join(path, "\\#{file}.#{extension}").gsub(/\\/,'\\\\\\')

      end
  
      def self.create_live_data_point(meter, open_ldc, live_data_folder)

        source_file = double_dash(live_data_folder, meter.billing_id, "sli" )

        ldc_row = open_ldc.new_row_object("wn_live_data_point")

        ldc_row.live_data_point_id = meter.billing_id
        ldc_row.source_file = source_file
        ldc_row.write

        puts ldc_row.methods

      end


    end
  end