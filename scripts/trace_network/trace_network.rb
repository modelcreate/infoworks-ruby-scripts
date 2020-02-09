def trace_link(link, max_size)

  max_dia = link.table == "wn_pipe" ? link.diameter : max_size

  link._seen = true
  link.selected = true

  nodes = link.navigate("us_node") + link.navigate("ds_node")

  nodes.each do |n|
    unless n._seen == true
      puts "At node #{n.id} with max_dia of #{max_dia}"
      trace_node(n, max_dia)
    else
      puts "Ended at #{n.id}"
    end
  end

end


def trace_node(node, max_size)

  node._seen =  true
  node.selected = true

  links = node.navigate("us_links") + node.navigate("ds_links")

  links.each do |l|
    unless l.diameter.nil? || l.diameter > max_size || l._seen == true
      puts "At link #{l.id} with max_dia of #{max_size}"
      trace_link(l, max_size)
    else
      puts "Ended at #{l.id} "
    end
  end
  

end


# Get a copy of the current open network
net = WSApplication.current_network

# Get an array of all selected links
selected = net.row_objects_selection('_links')

# Ensure we are only working from a single selection
if selected.length == 1

  # Each function returns the US and DS node which are added together
  # to make a single array
  nodes =  arr[0].navigate("us_node") + arr[0].navigate("ds_node")

  # Start tracing out from each of the nodes and finding pipes
  # that are the same diameter or smaller
  nodes.each do |n|
    trace_node(n, arr[0].diameter)
  end

else
  puts "Select a single link only"
end
