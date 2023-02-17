# Load the library of helper modules that will be used to allocate customers
# Normally in Ruby you could just use:
# require 'lib/split_links'
# However I had problems with realtive paths, so this is the workaround
script_path = File.dirname(__FILE__)
$LOAD_PATH.unshift script_path + '\lib'
load  script_path + '\lib\split_links.rb'


split_links = IwpBuild::SplitLinks.new(net)
net.transaction_begin

['wn_hydrant','wn_node'].each { |type|
  split_links.at_node_collection(type)
}
split_links.at_intersections

net.transaction_commit
