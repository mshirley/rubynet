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

puts "### ---- ### Loading Complete ### ---- ###"

puts "### ---- ### Starting Service ### ---- ###"
set :port, 4563
use Rack::Session::Pool, :domain => "rubynet.lol", :expire_after => 2592000
#enable :sessions

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

get '/node/:id/:command/:optional1/:optional2' do
	case params[:command]
	when "auth"
		inventory_check(params[:id])
		nodeip = @env['REMOTE_ADDR']
		if params[:optional1] == $masterkey.chomp
			response.set_cookie('auth', :value => "yes")
			"you are authenticated\n"
			#add_session(nodeip, params[:node])
		else
		end
	when "gdownload"
		file = File.join('./files/', params[:optional1])
		send_file(file, :disposition => 'attachment', :filename => File.basename(file))
	when "mdownload"
		"master download\n"
	when "register"
		if session[:authed] == "yes"
			if params[:optional1] == $masterkey.chomp
				register(params[:id])
			else
				"incorrect master key"
			end
		else
			"you are not authenticated"
		end
	when "list"
		"list\n"
	when "clear"
		session[:authed] = "no"
		"session cleared\n"
	else 
		"invalid command\n"
	end
end

delete '/nodes/:id' do
end
end # ocra end
