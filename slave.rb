require 'net/http'

def load_db()
key = ""
masterkey = ""
configs = ["node.dat", "masters.dat"]

configs.each { |i|
puts i
if File.exists?(i) && i == "node.dat"
	puts "Node configuration found, loading..."
	nodedata = File.open(i,"r")
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
}
return key

end

def fetch(http, url)
	#puts url
	response = http.get(url)
	return response
end

def auth(http, key, masterkey)
	puts "authenticating"
	response = fetch(http, "/node/#{key}/register/#{masterkey}/noop")
	return response
end

def register(http, key, masterkey)
	puts "registering"
	response = fetch(http, "/node/#{key}/auth/#{masterkey}/optional2")
	return response
end

host = "localhost"
port = "4563"
nodeid = "0987654321"
masterkey = "1234567890"
cookie = ""

key = load_db()
def init(host, port, key, masterkey)
	begin
		http = Net::HTTP.new(host, port)
		response = auth(http, key, masterkey)
		response = register(http, key, masterkey)
	rescue Errno::ECONNREFUSED
		puts "server actively refusing"
	rescue Timeout::Error
		puts "timeout"
	end
return response
end

init(host, port, key, masterkey)
#puts resp.response['set-cookie'].split('; ')[0]
#puts resp.response['set-cookie'].split('; ')[0]
#puts cookie
#while 1 == 1
#	sleep rand(15) 
#puts auth(host, port, nodeid, masterkey)
#puts register(host, port, nodeid, masterkey)
#end
