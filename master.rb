#!/usr/bin/ruby
require 'socket'
require 'zlib'
require 'base64'
inventory = []
if not defined?(Ocra)
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

while (session = server.accept)
 Thread.start do
	time = Time.new
	puts time.strftime("%Y-%m-%d %H:%M:%S") + "-- connection from #{session.peeraddr[3]} opened"
   	nodekey = session.gets
	nodekey = nodekey.chomp
   	puts "nodekey #{nodekey}"
	if inventory.include?(nodekey)
		session.puts "Welcome: #{nodekey}"
		request = session.gets
		request = request.chomp
		session.puts "PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD"
#		response = session.gets
#		response = response.chomp
#		if response == "ok"
#			puts "OK Recieved - Payload pushed to #{nodekey}"
#		else
#			puts "OK NOT RECIEVED - PROBLEM with #{nodekey}"
#			session.close
#		end
		

		hostdata = []
		while dataline = session.gets
			hostdata << dataline
		end
		puts hostdata
		decompString = Zlib::Inflate.inflate hostdata.to_s 
		puts decompString	
		File.open("nodedata.dat", "a") { |f| f.write(decompString) }
		puts "connection from #{session.peeraddr[3]} closed"
	else
		session.close
	end   
  end
end
end
