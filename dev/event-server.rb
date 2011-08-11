require 'rubygems'
require 'eventmachine'

# this is a global variable so it can be touched by everything
$connected = []

def add_connected(nodename, nodeip)
        puts "add_connection function executed"
        $connected << "nodename=#{nodename}:nodeip=#{nodeip},"
        return
end

def print_connected()
        puts "print_connected function executed"
        return $connected
end

def parse_input(input)
        input = input.strip
        case input
        when "print_connected"
                puts "The 'print_connected' command has been executed"
                return print_connected()
        when "close_connected"
                puts "The 'close_connected' command has been executed"
                return "command executed"
        else
                puts "failbomb"
                return "invalid command"
        end
end

class Echo < EM::Connection
  def receive_data(data)
	breakit = 0
	while breakit == 0
		puts data
		breakit = 1
	end	
	send_data("HI THERE" + data)
  end
end

EM.run do
	EM.start_server("0.0.0.0", 10000, Echo)
end
