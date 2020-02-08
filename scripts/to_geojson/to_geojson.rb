require 'date'
require 'json'

config = {
  "crs"=>  {
    "type"=>  "name",
    "properties"=>  {
      "name"=>  "urn:ogc:def:crs:EPSG::27700"
    }
  },
  "tables"=>  [{
      "name"=>  "_nodes",
      "type"=>  "point",
      "fields"=>  ["node_id","z","user_text_1","user_text_2","user_text_3","user_text_4","user_text_5","user_text_6"],
      "results"=>  ["pressure","demand","leakage"],
      "result"=>  ["totdemnd","totleak"]
    },{
      "name"=>  "_links",
      "type"=>  "line",
      "fields"=>  ["us_node_id","ds_node_id","link_suffix","diameter","material","year","user_text_1","user_text_3","user_text_3","user_text_4","user_text_5","user_text_6","user_text_7","user_text_8"],
      "results"=>  ["flow"],
      "result"=>  []
    }
  ]
}

class Float
  def signif(signs)
    Float("%.#{signs}g" % self)
  end
end

class IwGeojson
  def initialize(network, config, is_sim)
    @network = network
    @config = config
    @is_sim = is_sim
    @features = []
    @json = {
      "type" => "FeatureCollection",
      "features" => @features,
      "crs" => @config["crs"],
      "model" => {
        "timesteps" => is_sim ? @network.list_timesteps : nil
      }
    }

    extract_network
  end

  def to_geojson
    @json.to_json
  end

  private

  def extract_network

    @config["tables"].each do |table|
      if table["type"] == "point"
        @network.row_object_collection(table["name"]).each do |ro|
          add_point_feature(ro, table)
        end
      elsif table["type"] == "line"
        @network.row_object_collection(table["name"]).each do |ro|
          add_line_feature(ro, table)
        end
      end
    end
  end

  def add_line_feature(ro, table)
    @features.push(
      {
        "type" => "Feature",
        "geometry" => {
          "type" => "LineString",
          "coordinates" => ro.bends.collect() { |x| (x <= 1) ? x.signif(2) : x.round(2) }.each_slice(2).to_a
        },
        "properties" => get_properties(ro, table)
      }
    )
  end

  def add_point_feature(ro, table)
    @features.push(

      {
        "type" => "Feature",
        "geometry" => {
          "type" =>  "Point",
          "coordinates" =>  [ro.x.round(2), ro.y.round(2)]
        },
        "properties" =>  get_properties(ro, table)
      }
    )
  end

  def get_properties(ro, table)

    props = {
      "table" => ro.table
    }

    table["fields"].each do |field|
      props[field] = ro[field]
    end

    if @is_sim

      table["results"].each do |field|
        props[field] = ro.results(field).collect { |x| (x <= 1) ? x.signif(2) : x.round(2) }
      end
  
      table["result"].each do |field|
        props[field] =  (ro.result(field) <= 1) ? ro.result(field).signif(2) : ro.result(field).round(2)
      end

    end

    props

  end

end

net=WSApplication.current_network

begin
  is_sim =  (net.current_timestep > -2) ? true : nil
rescue => exception
  if exception.message == "current_timestep: method cannot be run on a network without loaded results"
    is_sim = false
  else
    raise exception
  end
end

#.model_object only existing on the latest versions of IW
begin
  mo = net.model_object 
  name = mo.name
rescue => exception
 name = "Model Extract"
end


file=WSApplication.file_dialog(false, "json", "GeoJson file",name,false,false) 
if file.nil? 
  puts "Model extraction canceled"
else
  geojson = IwGeojson.new(net, config, is_sim).to_geojson
  File.open(file,'w') do |f|
    f.write(geojson)
  end

  puts "GeoJSON extracted:"
  puts file
end
