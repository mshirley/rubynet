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

# node registration function
def register(id)
	if inventory_check(id) == "valid"
		return "ERROR: this node is already registered"
	else
		$inventory << id
		return "OK: this node has been registered"
	end
end

# this will check the global inventory array for a node id
def inventory_check(id)
	if $inventory.include?(id)
		return "valid"
	else
		return "invalid"
	end
end

# nothing here yet
def add_session(nodeip, node)
		
	
end

# reads a .job file for a specific node
def get_jobs(id)
	output = []
	if File.exist?("./files/jobs/#{id}.job")
		jobs = IO.readlines("./files/jobs/#{id}.job")
		"#{jobs}"
#		File.open("./files/jobs/#{id}.job", 'w') {|file| file.truncate(0)}
	else
		"no #{id}.job"
	end
end

def clear_jobs(id)
	file = "./files/jobs/#{id}.job"
	if File.exist?("./files/jobs/#{id}.job")
		File.open(file, 'w') { |file| file.truncate(0) }
		
	else
		"no #{id}.job"
	end
end

puts "### ---- ### Loading Complete ### ---- ###"

puts "### ---- ### Starting Service ### ---- ###"
set :port, ARGV[0] 
use Rack::Session::Pool, :domain => "rubynet.lol", :expire_after => 2592000
#enable :sessions

# this defines the file upload post handler
post '/upload/:area/:id/:filename' do
	# the jobs and data directory must exist under ./files/
	if params[:area] == "jobs" || params[:area] == "data"
		if inventory_check(params[:id]) == "valid"
			filename = File.join("./files/", params[:area], "/", params[:id] + "-" + Time.now.strftime("%m-%d-%y-%Hh%Mm%Ss-") + params[:filename])
			datafile = params[:data]
			File.open(filename, 'wb') do |file|
				file.write(datafile[:tempfile].read)
			end
			"wrote to #{filename}\n"
		else
			"invalid id -- id used: #{params[:id]}"
		end
	else
		"incorrect area"
	end
end

# main request function with specific commands and arguments
get '/node/:id/:command/:optional1/:optional2' do
	case params[:command]
	# Still not working, sessions aren't sticking
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
	when "getjobs"
		get_jobs(params[:id])	
	when "clearjobs"
		clear_jobs(params[:id])
	else 
		"invalid command\n"
	end
end

delete '/nodes/:id' do
end
end # ocra end
