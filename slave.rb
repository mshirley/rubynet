require 'net/http'

def fetch(http, url)
	puts url
	resp = http.get(url)
	return resp
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

http = Net::HTTP.new(host, port)

resp = fetch(http, "/node/id/clear/asdf/asdf")
puts resp.response['set-cookie'].split('; ')[0]
resp = fetch(http, "/node/0987654321/register/1234567890/noop")
puts resp.response['set-cookie'].split('; ')[0]
resp = fetch(http, "/node/0987654321/auth/1234567890/optional2")
puts resp.response['set-cookie'].split('; ')[0]
resp = fetch(http, "/node/id/clear/asdf/asdf")
puts resp.response['set-cookie'].split('; ')[0]
puts cookie
#puts auth(host, port, nodeid, masterkey)
#puts register(host, port, nodeid, masterkey)
