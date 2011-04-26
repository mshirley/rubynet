require 'pcaplet'

# create a sniffer that grabs the first 1500 bytes of each packet
$network = Pcaplet.new('-s 1500')

# create a filter that uses our query string and the sniffer we just made
$filter = Pcap::Filter.new('tcp and dst port 80', $network.capture)

# add the new filter to the sniffer
$network.add_filter($filter)

# iterate over every packet that goes through the sniffer
for p in $network
  # print packet data for each packet that matches the filter
  puts p.tcp_data if $filter =~ p
end

