#!/usr/bin/ruby

require 'rubygems'
require 'sinatra'
puts "### ---- ### Loading ### ---- ###"

# Ocra is the ruby2exe app we're using.  this if loop prevents the compiler from executing it.
if not defined?(Ocra)

def load_inv()
        $inventory = []
        if File.exist?("inventory.dat")
                puts "inventory found, loading..."
                inventorydat = File.open("inventory.dat", "r")
                puts "inventory loaded"
                $masterkey = inventorydat.readline
                puts "masterkey is #{$masterkey}"
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

def register(id)
	
	if inventory_check(id) == "valid"
		return "ERROR: this node is already registered"
	else
		$inventory << id
		return "OK: this node has been registered"
	end

end

def inventory_check(id)
	if $inventory.include?(id)
		return "valid"
	else
		return "invalid"
	end
end

def add_session(nodeip, node)
		
	
end

def test
	puts "this is a test"
	return "yea this is interesting"

end

puts "### ---- ### Loading Complete ### ---- ###"

puts "### ---- ### Starting Service ### ---- ###"
set :port, 4563
#use Rack::Session::Pool, :domain => "rubynet.lol", :expire_after => 2592000
enable :sessions

get '/node-list/:masterkey' do
# put an array of all registered hosts
end

get '/node-register/:id/:master' do
	if params[:master] == $masterkey.chomp 
		register(params[:id])
	else
		"incorrect master key"
	end
end

get '/download/:filename' do |filename| # use |filename, id| with /download/:filename/:id
	file = File.join('./files/', filename)
	send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end

post '/upload/:filename/:id' do
	if inventory_check(params[:id]) == "valid"
		filename = File.join("./files/", params[:filename])
		datafile = params[:data]
		File.open(filename, 'wb') do |file|
			file.write(datafile[:tempfile].read)
		end
		"wrote to #{filename}\n"
	else
		"invalid id"
	end
end

#get '/node-auth/:node/:key' do
#	inventory_check(params[:node])
#	nodeip = @env['REMOTE_ADDR']
#	if params[:key] == $masterkey.chomp
#		session[:authed] = "yes"
#		# no real reason for session control yet
#		#add_session(nodeip, params[:node])
#	else
#	end
#end

get '/node-checkup/:id'	do
	
end

put '/node/:id' do
	"the id is #{params[:id]}"
end

delete '/nodes/:id' do
end
end # ocra end
