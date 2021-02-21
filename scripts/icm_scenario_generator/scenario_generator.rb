# Adapted from @ngerdts7 scenario generator script
# https://github.com/ngerdts7/ICM_Tools/blob/master/Scenario_Generator.rb 

net=WSApplication.current_network

# Define which parameters will be varied by the script. 
# param = name of ICM variable to be modified
# name  = abreviation of parameter to be used in scenario name
# table = name of table to be edited that contains the parameter
# id    = model ID in specified table where parameter changes are made (e.g. subcatchment ID, pipe ID, etc.)
# Range = [min, max, # of steps] -> define the range to be tested and how many steps you want the script to try.
#       Example: [0,1,5] -> will create 5 scenarios where the parameter ranges from 0 to 1 -> [0, 0.25, 0.5, 0.75, 1.0]

# Remove/add rows as needed to account for different variables.

modifications = [
    { 'param'=> "p_area_1",                'name'=>"p1", 'table'=>'hw_land_use',            'id'=>'12430',  'range'=>[0.3,1,2] },
    { 'param'=> "p_area_2",                'name'=>"p2", 'table'=>'hw_land_use',            'id'=>'12430',  'range'=>[10,20,2] },
    { 'param'=> "percolation_coefficient", 'name'=>"pc", 'table'=>'hw_ground_infiltration', 'id'=>'12430',  'range'=>[10,30,2] },
    { 'param'=> "percolation_threshold",   'name'=>"pt", 'table'=>'hw_ground_infiltration', 'id'=>'12430',  'range'=>[2,10,3] },
    { 'param'=> "percolation_percentage",  'name'=>"pp", 'table'=>'hw_ground_infiltration', 'id'=>'12430',  'range'=>[40,80,3] },
    { 'param'=> "baseflow_coefficient",    'name'=>"bc", 'table'=>'hw_ground_infiltration', 'id'=>'12430',  'range'=>[15,25,2] },
    { 'param'=> "infiltration_coefficient",'name'=>"ic", 'table'=>'hw_ground_infiltration', 'id'=>'12430',  'range'=>[30,50,2] },
    { 'param'=> "runoff_routing_value",    'name'=>"rv", 'table'=>'hw_runoff_surface',      'id'=>'2',      'range'=>[10,20,2] }
]


# range_array 
#   [min, max, # of steps] -> define a range of values to be tested and how many steps you want between them.
# 
# Returns:
#   [number, number, number...]
#
# Example: 
#   [0,1,5] -> will return 5 values where the parameter ranges from 0 to 1 -> [0, 0.25, 0.5, 0.75, 1.0]
#
def create_range(range_array)
    min, max, steps = range_array
    dx = (max - min) / (steps - 1)
	return Array.new(steps) { |i| i*dx+min }
end

# Assemble unique scenario name based on parameter composition
# The following modifications:
#   p_area_1 = 0.3              baseflow_coefficient= 15
#   p_area_2 = 10               infiltration_coefficient= 30
#   runoff_routing_value = 10   percolation_coefficient = 10 
#   percolation_threshold = 2 
#
# Are given the unique scenario name of:
#    p1=0.3_p2=10_pc=10_pt=2_pp=40_bc=15_ic=30_rv=10
#
def create_scenario_name(modifications)
    modifications.reduce('') do |acc, mod|
        name, value = mod.values_at( "name", "value")
        acc << "#{name}=#{value}_"
    end
end

# create_scenario generates a single new scenario and applies parameter changes
# based an array of modifications passed into the function. This method is called
# in a loop to create many scenarios.
# 
# Example:
#   modifications = [
#       {"param"=>"p_area_1", "name"=>"p1", "table"=>"hw_land_use", "id"=>"12430", "value"=>0.3}, 
#       {"param"=>"p_area_2", "name"=>"p2", "table"=>"hw_land_use", "id"=>"12430", "value"=>10}, 
#       {"param"=>"percolation_coefficient", "name"=>"pc", "table"=>"hw_ground_infiltration", "value"=>10},
#   ]
#
#  Will create a scenario with the name:
#   p1=0.3_p2=10_pc=10
#
#  With the following modifications on the scenario
#   p_area_1 = 0.3     percolation_coefficient = 10 
#   p_area_2 = 10 
#
def create_scenario(modifications, net)

    scenario_name = create_scenario_name(modifications)

    net.add_scenario(scenario_name,nil,'') 
    puts " *** Creating scenario #{scenario_name}"

    net.current_scenario=scenario_name
	net.clear_selection
	net.transaction_begin

    # Loop through each of the modifications and update the row object in the database
    modifications.each do |mod|
        param, name, table, id, value = mod.values_at("param", "name", "table", "id", "value")
        puts "    -  id: #{id}, table: #{table}, param: #{param}, value: #{value}"

        row_obj = net.row_object(table,id)
        row_obj[param] = value
        row_obj.write

    end

    net.transaction_commit
	net.validate(scenario_name)

end


# Loops through the modifications and calculates the individual values from the range of values
scenarios = modifications.reduce([]) do |acc, mod|
    acc << create_range( mod['range'] ).map{ |i| mod.clone.merge!( {'value'=> i}) } 
end

# In Ruby, Product is an array function that returns an array of all combinations of elements from all arrays.
outputs = scenarios.shift.product(*scenarios)

# UI confirmation on creating scenarios
text = "Do you want to create #{outputs.length} scenarios?"
result = WSApplication.message_box(text,nil,"?",false)

if result == "Cancel"
    exit
end

# Loop through each unique combination of modification varables and create a scenario
outputs.each_with_index do |x,i|
    puts "Scenario: #{i} - #{x.to_s}"
    create_scenario(x, net)
end
