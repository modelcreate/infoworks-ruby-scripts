# Example to run validation on a network
#
# API documentation incorrectly says to call .object_message to get the validation message
# however it should actually be .message


net = WSApplication.current_network
vals = net.validate

puts "Error count: #{vals.error_count}"
puts "Warning count: #{vals.warning_count}"

puts ""

puts "Type | Priority | Code | Field | Description | Object ID | Object Type | Message"
vals.each do |v|
  puts "#{v.type} - #{v.priority} -#{v.code} - #{v.field} - #{v.field_description}- #{v.object_id} - #{v.object_type} - #{v.message}"
end
