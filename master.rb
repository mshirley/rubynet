#!/usr/bin/ruby

require 'rubygems'
require 'sinatra'
require 'lib/mjobs'
require 'lib/load_mdata'

puts "### ---- ### Loading ### ---- ###"

# Ocra is the ruby2exe app we're using.  this if loop prevents the compiler from executing it.
if not defined?(Ocra)

load_inv()

puts "### ---- ### Loading Complete ### ---- ###"

puts "### ---- ### Starting Service ### ---- ###"
if ARGV[0].nil?
	set :port, 1234
else
	set :port, ARGV[0] 
end
use Rack::Session::Pool, :domain => "rubynet.lol", :expire_after => 2592000
#enable :sessions

# this defines the file upload post handler
post '/upload/:area/:id/:filename' do
	# the jobs and data directory must exist under ./files/
	if params[:area] == "jobs" || params[:area] == "data"
	#	if inventory_check(params[:id]) == "valid"
			filename = File.join("./files/", params[:area], "/", params[:id] + "-" + Time.now.strftime("%m-%d-%y-%Hh%Mm%Ss-") + params[:filename])
			puts "Filename is : #{filename}"
			datafile = request.env["rack.input"].read #params[:data]
			puts "Datafile class is : #{datafile.class}"
			File.open(filename, 'wb') do |file|
				puts datafile
				file.write(datafile)
			end
			"wrote to #{filename}\n"
	#	else
	#		"invalid id -- id used: #{params[:id]}"
	#	end
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
