require 'net/http'

def load_db()
if File.exists?("node.dat")
	puts "Node configuration found, loading..."
	nodedata = File.open("node.dat","r")
	puts "Node configuration loaded"
	nodedata.each do |line|
		$key = line.chomp
	end
	puts "Key is #{$key}"
else
	puts "Node configuration not found, creating..."
	nodedata = File.new("node.dat", "w")
	o = [('a'..'z'),('A'..'Z'),('0'..'9')].map{ |i| i.to_a }.flatten
	$key = (0..50).map { o[rand(o.length)] }.join
	nodedata.puts($key)
	puts "Generating key... #{$key}"
	nodedata.close
end
end

def fetch(http, url)
	#puts url
	response = http.get(url)
	return response
end

def auth(host, port, id, masterkey)
	puts "authenticating"
	response = fetch("http://" + host + ":" + port + "/node/" + id + "/auth/" + masterkey + "/noop")
	return response
end

def register(host, port, id, masterkey)

	puts "registering"
	response = fetch("http://" + host + ":" + port + "/node/" + id + "/register/" + masterkey + "/noop")
	return response
end

host = "localhost"
port = "4563"
nodeid = "0987654321"
masterkey = "1234567890"
cookie = ""

load_db()

http = Net::HTTP.new(host, port)
while 1 == 1
resp = fetch(http, "/node/#{$key}/register/1234567890/noop")
#puts resp.response['set-cookie'].split('; ')[0]
resp = fetch(http, "/node/#{$key}/auth/1234567890/optional2")
#puts resp.response['set-cookie'].split('; ')[0]
#puts cookie
sleep rand(15) 
#puts auth(host, port, nodeid, masterkey)
#puts register(host, port, nodeid, masterkey)
end
