require 'rubygems'
require 'net/http/post/multipart'

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

def register(host, port, key, masterkey)
        response = fetch(host, port, "/node/#{key}/register/#{masterkey}/optional2")
        return response
end

register("localhost", "1234", "N0HmRw7e2QHKkvBm0fLfreVIkSyfp7BwCpBGjzZjofYHAOtyqiL", "1234567890")

url = URI.parse('http://localhost:1234/upload/data/N0HmRw7e2QHKkvBm0fLfreVIkSyfp7BwCpBGjzZjofYHAOtyqiL/test')

data = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
headers = {
  'data' => 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
}
http = Net::HTTP.new("localhost", "1234")
path = "/upload/data/N0HmRw7e2QHKkvBm0fLfreVIkSyfp7BwCpBGjzZjofYHAOtyqiL/test"
resp, data = http.post(path, data)

