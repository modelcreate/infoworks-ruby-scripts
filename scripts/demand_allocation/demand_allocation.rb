script_path = File.dirname(__FILE__)
$LOAD_PATH.unshift script_path + '\lib'
load  script_path + '\lib\customer_allocation.rb'


allocation_steps = [
  {"distance" => 100, "steps" => 10, "max_dia"=> 299},
  {"distance" => 20, "steps" => 1, "max_dia"=> 600},
  {"distance" => 500, "steps" => 10, "max_dia"=> 299},
  {"distance" => 100, "steps" => 1, "max_dia"=> 600},
  {"distance" => 1000, "steps" => 10, "max_dia"=> 299},
  {"distance" => 200, "steps" => 1, "max_dia"=> 600},
  {"distance" => 1500, "steps" => 10, "max_dia"=> 299}
]

start = Time.now

net = WSApplication.current_network

polys = net.row_objects('wn_polygon')

polygons = polys.select {|p| p.selected == true}
if polygons.length == 0
  WSApplication.message_box 'No polygon selected - no allocation will be performed','OK',nil,false
end

polygons.each do |poly|

  if poly.area_code == ""
    puts "Polygon: #{poly.id}, does not have an area code set - no allocation will be performed"
    next
  end

  puts "Allocating customers in #{poly.id}"

  custs = poly.objects_in_polygon("wn_address_point")

  if custs.nil?
    puts "No customer points within #{poly.id}"
    next
  end

  net.transaction_begin
  custs.each do |c|
    success = false
    allocation_steps.each do |al|
      next unless success == false 
      success = CustomerAllocation::Allocator::allocate_customer( net, c, poly.area_code, al["distance"], al["steps"], al["max_dia"])
    end

    if success == false
      puts "#{cust.id} could not be allocated"
    end

  end

  net.transaction_commit

end


# code to time
finish = Time.now
diff = finish - start

puts "Customer allocation finished in #{diff.round(2)} seconds"