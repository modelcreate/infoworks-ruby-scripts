def create_scenario_name(modifications)
    modifications.reduce('') do |acc, mod|
        name, value = mod.values_at( "name", "value")
        acc << "#{name}=#{'%.2f' % value}_"
    end
end


def create_scenario(modifications, net)

    scenario_name = create_scenario_name(modifications)

    #net.add_scenario(scenario_name,nil,'') 
    puts " *** Creating scenario #{scenario_name}"

    #net.current_scenario=scenario_name
	#net.clear_selection
	#net.transaction_begin

    # Loop through each of the modifications and update the row object in the database
    modifications.each do |mod|
        param, name, table, id, value = mod.values_at("param", "name", "table", "id", "value")
        puts "    -  id: #{id}, table: #{table}, param: #{param}, value: #{value}"

        #row_obj = net.row_object(table,id)
        #row_obj[param] = value
        #row_obj.write

    end

    #net.transaction_commit
	#net.validate(scenario_name)

end


net=WSApplication.current_network


polygon_list = net.row_objects('wn_polygon').map { |n| [n.polygon_id,'BOOLEAN',false] }


#arr = WSApplication.prompt(
#    "Select areas to modify",
#    [
#        ['Zone 1','BOOLEAN',false],
#        ['Zone 2','BOOLEAN',false],
#        ['Zone 3','BOOLEAN',false]
#    ], true
#)

user_polygon_selections = WSApplication.prompt(
    "Select areas to modify",
    polygon_list,
    true
)

selected_polygons = []

user_polygon_selections.each_with_index do |selected, index|
    if selected
        id = polygon_list[index][0]
        ro = net.row_object("wn_polygon", id)
        selected_polygons << ro
    end
end

if selected_polygons.length == 0
    puts "No areas selected, please select at leastt one area"
    exit
end


scenario_params = WSApplication.prompt(
    "Configure parameters",
    [
        ['Initial Infiltration - Reduction Rate (%)','NUMBER',30,1],
        ['Initial Infiltration - Count of Reductions','NUMBER',5,0],
        ['Decay Factor - Reduction Rate (%)','NUMBER',30,1],
        ['Decay Factor - Count of Reductions','NUMBER',5,0]
    ], true
)


## Check values are sensible
ii_reduct_rate, ii_reduct_count, decay_reduct_rate, decay_reduct_count = scenario_params

errors = false

if ii_reduct_rate <= 0 || ii_reduct_rate >= 100
    puts "ERROR: Initial Infiltration - Reduction Rate must be between 0% and 100%"
    puts "       - Was set to #{ii_reduct_rate}%"
    puts ""
    errors = true
end

if ii_reduct_count <= 0 || ii_reduct_count >= 20
    puts "ERROR: Initial Infiltration - Count of Reductions must be between 1 and 20"
    puts "       - Was set to #{ii_reduct_count}"
    puts ""
    errors = true
end

if decay_reduct_rate <= 0 || decay_reduct_rate >= 100
    puts "ERROR: Decay Factor - Reduction Rate must be between 0% and 100%"
    puts "       - Was set to #{decay_reduct_rate}%"
    puts ""
    errors = true
end


if decay_reduct_count <= 0 || decay_reduct_count >= 20
    puts "ERROR: Decay Factor - Count of Reductions must be between 1 and 20"
    puts "       - Was set to #{decay_reduct_count}%"
    puts ""
    errors = true
end

if errors
    puts ""
    puts "Please modify parameters and try again"
    exit
end

# UI confirmation on creating scenarios
text = "Do you want to create #{decay_reduct_count * ii_reduct_count - 1} scenarios?"
result = WSApplication.message_box(text,nil,"?",false)

if result == "Cancel"
    exit
end


decay_range = (0..decay_reduct_count).to_a
ii_range = (0..ii_reduct_count).to_a

ii_reduct_percent = (100 - ii_reduct_rate) / 100
decay_reduct_percent = (100 - decay_reduct_rate) / 100


scenarios = []

decay_range.each do |decay_index|
    ii_range.each do |ii_index|

        modifications = []

        selected_polygons.each_with_index do |ro, i|

            ii_value = ii_reduct_percent ** ii_index * ro.user_number_1
            decay_value = decay_reduct_percent ** decay_index * ro.user_number_2

            modifications << {"param"=>"initial_infiltration", "name"=>"ii_#{ro.polygon_id}", "table"=>"hw_runoff_surface", "id"=>"#{ro.polygon_id}", "value"=>ii_value}
            modifications << {"param"=>"decay_factor", "name"=>"df_#{ro.polygon_id}", "table"=>"hw_runoff_surface", "id"=>"#{ro.polygon_id}", "value"=>decay_value}
        end

        scenarios << modifications

        puts "decay - #{decay_index}, #{decay_reduct_percent ** decay_index} | ii - #{ii_index}, #{ii_reduct_percent ** ii_index}"

    end
end

# Loop through each unique combination of modification varables and create a scenario
scenarios.each_with_index do |x,i|
    puts "Scenario: #{i} - #{x.to_s}"
    create_scenario(x, net)
end



#  modifications = [
#      {"param"=>"initial_infiltration", "name"=>"2", "table"=>"hw_runoff_surface", "id"=>"2", "value"=>0.3}, 
#      {"param"=>"initial_infiltration", "name"=>"2", "table"=>"hw_runoff_surface", "id"=>"2", "value"=>0.3}, 
#      {"param"=>"initial_infiltration", "name"=>"2", "table"=>"hw_runoff_surface", "id"=>"2", "value"=>0.3}, 
#      {"param"=>"initial_infiltration", "name"=>"2", "table"=>"hw_runoff_surface", "id"=>"2", "value"=>0.3}, 
#  ]
#
#
#  create_scenario(modifications, net)