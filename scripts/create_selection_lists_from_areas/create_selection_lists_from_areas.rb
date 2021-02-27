
net = WSApplication.current_network
db = WSApplication.current_database

# Recurvsively look through the tree for selection lists and
# give the user a prompt to pick the correct selection list
def get_selection_group(db)
  selection_lists = Array.new
  toProcess=Array.new
  db.root_model_objects.each do |o|
    toProcess << o
  end
  while toProcess.size>0
    working=toProcess.delete_at(0)
    if working.type == "Selection List Group"
      selection_lists << working.path
    end
    working.children.each do |c|
      toProcess << c
    end
  end
  unless selection_lists.length == 0
    val=WSApplication.prompt "Create Selection List",
    [['Pick Selection Group','String',nil,nil,'LIST',selection_lists]],true
    if val[0].nil?
      exit
    else
      val[0].to_s
    end
  else
    puts "No selection list groups found, please create one first"
    exit
  end
end


mo_selection_group = db.model_object get_selection_group(db)
selection_lists = {}

# Create an array with all unique area codes
area_codes = net.row_objects('_links').map { |n| n.area }.uniq
area_codes << net.row_objects('_nodes').map { |n| n.area }.uniq

# Create selection lists for each area code
area_codes.flatten!.sort.each do |area_code|

  area_code = area_code == "" ? "NO AREA CODE" : area_code

  begin
    selection_lists[area_code] = mo_selection_group.new_model_object('Selection List', area_code)
  rescue RuntimeError => e
    if e.message == "name already in use"
      # Selection list already exists so lets grab a reference
      selection_lists[area_code] = db.model_object "#{mo_selection_group.path}>SEL~#{area_code}"
    else
      raise
    end
  end
end


# create a hash with each area code being a key
# add each row object to the hash at its area code
areas = {}
['_nodes','_links'].each do |type|
  net.row_objects(type).each do |ro|

    area_code = ro.area == "" ? "NO AREA CODE" : ro.area

    areas[area_code] = [] unless areas.key?(area_code)
    areas[area_code].push(ro)
  end
end

# create a hash of each node and the customers associated with it
node_cust_allocation = {}
net.row_objects('wn_address_point').each do |cust|
  next if cust.allocated_pipe_id == ""
  us_or_ds = (cust.demand_at_us_node ? 0 : 1)
  node_id = cust.allocated_pipe_id.split(".")[us_or_ds]

  node_cust_allocation[node_id] = [] unless node_cust_allocation.key?(node_id)
  node_cust_allocation[node_id].push(cust)
end


net.clear_selection

# loop through the area hash and select and save all objects with that area code
areas.each do |key, area|
  area.each do |ro|
    ro.selected = true
    # check if ro has customer allocations and select them as well
    if node_cust_allocation.key?(ro.id)
      node_cust_allocation[ro.id].each do |cust|
        cust.selected = true
      end
    end
  end
  puts "Saving #{key}"
  net.save_selection selection_lists[key]
  net.clear_selection
end

