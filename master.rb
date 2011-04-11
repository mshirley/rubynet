#!/usr/bin/ruby
require 'socket' 
require 'zlib' # compression
require 'base64' # not needed anymore but might be useful later
require 'rubygems'
require 'eventmachine' # runs our threading

# Ocra is the ruby2exe app we're using.  this if loop prevents the compiler from executing it.
if not defined?(Ocra)

# This function loads an inventory file, loads a masterkey and then loads slave node keys.  It will also create a blank dat file if it doesn't already exist
def load_inv()
	$inventory = []
	if File.exist?("inventory.dat")
		puts "inventory found, loading..."
		inventorydat = File.open("inventory.dat", "r")
		puts "inventory loaded"
		masterkey = inventorydat.readline
		puts "masterkey is #{masterkey}"
		puts "importing existing units"
		inventorydat.each do |line| 
			line = line.chomp
			$inventory << line
		end
		puts "units loaded"
		puts $inventory
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
end

load_inv()

# this is a global variable so it can be touched by everything
$connected = []

def parse_input(input)

end

def add_connected(nodename, nodeip, nodeport)
	puts "add_connection function executed"
	$connected << "nodename=#{nodename}:nodeip=#{nodeip}:nodeport=#{nodeport},"
	return
end

def print_connected()
	puts "print_connected function executed"
	return $connected.to_s
end

def check_inv(nodekey)
	if $inventory.include?(nodekey)
		return "authenticated"
	else
		return "unauthenticated"
	end
end

$jobq = ["0987654321:scan:host=1.1.1.1,speed=fast", "5432167890::scan:host=1.1.1.1,speed=fast", "0987654321:scan:host=2.2.2.2,speed=slow"]
def jobq_pull(nodekey)
	tempq = []
	$jobq.each { |j|
		if j.include?("#{nodekey}")
			tempq << j << "#"
			$jobq.delete(j)
		end
	}	
	puts tempq	
	puts "new job queue #{$jobq}"
	return tempq 
end

class Main < EM::Connection
  def post_init
	nodeport, nodeip = Socket.unpack_sockaddr_in(get_peername)
	puts "Node ip is: #{nodeip}"
	nodename = rand(10 ** 10)
	puts "Node name is: #{nodename}"
	add_connected(nodename, nodeip, nodeport)
	send_data("ready")
  end

  def receive_data(data)
        breakit = 0
        while breakit == 0
		key = data.split(":")[0]
		puts "Node key is #{key}"
		send_data(jobq_pull(key))
		breakit = 1	
        end
  end
end

class CC < EM::Connection
  def post_init
	send_data("Enter Pass: ")
  end
  
  def receive_data(data)
	breakit = 0 
	while breakit == 0
		send_data("# ")
		parse_input(data)
		puts data
		breakit = 1
	end
  end
end


EM.run do
        EM.start_server("127.0.0.1", 10000, Main)
	EM.start_server("127.0.0.1", 10001, CC)
end
end # ocra end

=begin
                if inputresult.strip == "invalid" || inputresult.strip == "not authenticated"
                        puts "malformed client request"
                        breakit = 1
                else
#                       send_data("#{parse_input(data)}\n")
                        breakit = 1
                end
=end

=begin
def parse_input(input)
	if input.include?(":")
		puts input.strip
		key = input.split(":")[0]
		if check_inv(key) == "authenticated"
			command = input.split(":")[1].strip
		else
			return "not authenticated"
		end
	else
		return "invalid"
	end	

	case command 
	when "connected"
		return print_connected() 
	when "close_all"
		puts "close_all'"
		return "command executed"
	when "help"
		return "
Commands:
All commands must be prefixed with your node id

print_connected -- prints info about current nodes
"	
	when "auth?"
		return "authok"
	else
		puts "unknown return code for #{command}"
		return "Unknown command"
	end
end	
=end


=begin
server = TCPServer.new(2008)

# This is where most of the action happens.  every new connection will create a new thread.  this will likely change significantly for persistent connections
while (session = server.accept)
 Thread.start do
	# Any "puts" will go to the console for debug.  session.gets will receive a line of data from the connected client        
	sessionid = session.object_id.abs
	nodeip = session.peeraddr[3]
        time = Time.new
        puts time.strftime("%Y-%m-%d %H:%M:%S") + "-- connection from #{nodeip} opened -- session id #{sessionid}"
	add_connected(sessionid, nodeip)
	while 0 < 1
		datain = session.gets
		#session.puts parse_input(datain)
		puts "data recieved #{datain}"
	end

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
=end
