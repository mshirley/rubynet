#!/usr/bin/ruby
require 'socket'

inventory = []

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
	puts "connection from #{session.peeraddr[2]} at #{session.peeraddr[3]}"
   	nodekey = session.gets
	nodekey = nodekey.chomp
   	puts "nodekey #{nodekey}"
	if inventory.include?(nodekey)
		session.puts "PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD-PAYLOAD"
		session.close
	else
		session.close
	end   
 end
end
