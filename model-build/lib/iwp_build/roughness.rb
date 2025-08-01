require "time"
module IwpBuild
  class Roughness



    def initialize(network)
      @network = network
      @year = Time.new.year
    end

    def set_roughness
      @network.transaction_begin

      @network.row_object_collection('_links').each do |ro|
        unless ro.material.nil? || ro.year.nil?
          k_value = get_roughness(ro.material, ro.year)
          unless k_value.nil?
            ro.k = k_value
            ro.k_flag = 'SD'
            ro.write
          end
        end
      end
      @network.transaction_commit

    end


    def get_roughness(material, year_laid)

      lookup = {
        "AC" =>   [[0.00, 0.03],[20.00, 0.06],[30.00, 0.08],[40.00, 0.10],[50.00, 0.20],[60.00, 0.30],[70.00, 0.40]],
        "AK" =>   [[0.00, 0.01]],
        "AL" =>   [[0.00, 0.01]],
        "BR" =>   [[0.00, 0.01]],
        "CI" =>   [[0.00, 0.03],[15.00, 0.05],[20.00, 0.88],[25.00, 1.00],[30.00, 1.50],[40.00, 2.00],[50.00, 2.50],[60.00, 3.00],[70.00, 3.50],[80.00, 4.00],[90.00, 5.00],[100.00, 6.00],[110.00, 7.50]],
        "CIL" =>  [[0.00, 0.03],[15.00, 0.05],[20.00, 0.88],[25.00, 1.00],[30.00, 1.50],[40.00, 2.00],[50.00, 2.50],[60.00, 3.00],[70.00, 3.50]],
        "CONC" => [[0.00, 0.06],[30.00, 0.15],[40.00, 0.30],[50.00, 0.50]],
        "CU" =>   [[0.00, 0.01]],
        "DI" =>   [[0.00, 0.15],[20.00, 0.30],[30.00, 0.60],[40.00, 0.90]],
        "DIL" =>  [[0.00, 0.15],[20.00, 0.30],[30.00, 0.60],[40.00, 0.90]],
        "FC" =>   [[0.00, 0.03],[20.00, 0.06],[30.00, 0.08],[40.00, 0.10],[50.00, 0.20],[60.00, 0.30],[70.00, 0.40]],
        "GI" =>   [[0.00, 0.60],[20.00, 1.00],[30.00, 1.50],[40.00, 2.00],[50.00, 2.50],[60.00, 3.00],[70.00, 3.50]],
        "GRP" =>  [[0.00, 0.01]],
        "GS" =>   [[0.00, 0.60],[20.00, 1.00],[30.00, 1.50],[40.00, 2.00],[50.00, 2.50],[60.00, 3.00],[70.00, 3.50]],
        "HDPE" => [[0.00, 0.01]],
        "HPPE" => [[0.00, 0.01]],
        "MDPE" => [[0.00, 0.01]],
        "Other" =>[[0.00, 0.50]],
        "PB" =>   [[0.00, 0.01]],
        "PE" =>   [[0.00, 0.01]],
        "PSC" =>  [[0.00, 0.06],[30.00, 0.15],[40.00, 0.30],[50.00, 0.50]],
        "PVC" =>  [[0.00, 0.03],[20.00, 0.06],[30.00, 0.09],[40.00, 0.12]],
        "PVCU" => [[0.00, 0.03],[20.00, 0.06],[30.00, 0.09],[40.00, 0.12]],
        "RC" =>   [[0.00, 0.06],[30.00, 0.15],[40.00, 0.30],[50.00, 0.50]],
        "SI" =>   [[0.00, 0.60],[20.00, 1.00],[30.00, 1.50],[40.00, 2.00],[50.00, 2.50],[60.00, 3.00],[70.00, 3.50]],
        "ST" =>   [[0.00, 0.30],[20.00, 1.00],[40.00, 2.00],[60.00, 3.00],[80.00, 5.00],[90.00, 7.50]],
        "TPL" =>  [[0.00, 0.03]],
        "UNK" =>  [[0.00, 0.50]],
        "uPVC" => [[0.00, 0.03],[20.00, 0.06],[30.00, 0.09],[40.00, 0.12]]
      }

      pipe_age = @year - year_laid

      result = lookup.detect{|k,v| k === material}
      
      k_value = nil
      unless result.nil?
        result.last.each do |age, roughness|
          if age <= pipe_age
            k_value = roughness
          else 
            break
          end
        end
        k_value
      end
      k_value

    end

  end
end
