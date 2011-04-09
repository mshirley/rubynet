#!/usr/bin/ruby
require 'socket' 
require 'zlib' # compression
require 'base64' # not needed anymore but might be useful later
inventory = []

# Ocra is the ruby2exe app we're using.  this if loop prevents the compiler from executing it.
if not defined?(Ocra)

# This loop loads an inventory file, loads a masterkey and then loads slave node keys.  It will also create a blank dat file if it doesn't already exist
if File.exist?("inventory.dat")
	puts "inventory found, loading..."
	inventorydat = File.open("inventory.dat", "r")
	puts "inventory loaded"
	masterkey = inventorydat.readline
	puts "masterkey is #{masterkey}"
	puts "importing existing units"
	inventorydat.each do |line| 
		line = line.chomp
		inventory << line
	end
	puts "units loaded"
	puts inventory
	inventorydat.close
else
	puts "no inventory found, creating new database"
	inventorydat = File.new("inventory.dat", "w")
	puts "populating db with master key and test units"
	inventorydat.puts("1234567890")
	inventorydat.puts("0987654321")
	inventorydat.puts("5432167890")
	inventorydat.close
end

server = TCPServer.new(2008)

# This is where most of the action happens.  every new connection will create a new thread.  this will likely change significantly for persistent connections
while (session = server.accept)
 Thread.start do
# Any "puts" will go to the console for debug.  session.gets will receive a line of data from the connected client          
	time = Time.new
	puts time.strftime("%Y-%m-%d %H:%M:%S") + "-- connection from #{session.peeraddr[3]} opened"
   	# The client should send it's key as the first part of our communication
        nodekey = session.gets
	nodekey = nodekey.chomp
   	puts "nodekey #{nodekey}"
        # Next we check our loaded inventory for the key that the node sent.  It should disconnect everything that isn't in the inventory.
	if inventory.include?(nodekey)
                # This is where all of our functions will run from.  The next sequence of events happens once per connection and then it closes.  
                # session.puts send data to the client
		session.puts "Welcome: #{nodekey}"
		request = session.gets
		request = request.chomp
		session.puts "PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD"

#  This is here as a template to create a session sync point to ensure the connection isn't messed up.  i'm sure we're reinventing the wheel
#  EventMachine will be better for this whole thing.
#
#		response = session.gets
#		response = response.chomp
#		if response == "ok"
#			puts "OK Recieved - Payload pushed to #{nodekey}"
#		else
#			puts "OK NOT RECIEVED - PROBLEM with #{nodekey}"
#			session.close
#		end
		
                # The node sends all of it's collected data and then post process
		hostdata = []
		while dataline = session.gets
			hostdata << dataline
		end
		puts hostdata
                # The data comes across compressed for obvious reasons
		decompString = Zlib::Inflate.inflate hostdata.to_s  # to_s converts the value of hostdata to a string
		puts decompString	
		File.open("nodedata.dat", "a") { |f| f.write(decompString) }
		puts "connection from #{session.peeraddr[3]} closed"
	else # any node not in the inventory get dropped
		session.close
	end   # main client run and node verification
  end #  thread loop
end # server session loop
end # ocra end
