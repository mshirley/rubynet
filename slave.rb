<<<<<<< HEAD
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
=======
require 'rubygems'
require 'socket'
require 'fileutils'
require 'rubygems'
require 'sys/host'
require 'sys/cpu'
require 'sys/filesystem'
require 'sys/proctable'
require 'sys/uname'
require 'sys/admin'
require 'zlib'
require 'digest/md5'
require 'base64'
require 'eventmachine'
include Sys
if not defined?(Ocra)

def system_info()
	
	data = []
	time = Time.new
	data << "####KEYKEYKEY##START##" + time.strftime("%Y-%m-%d-%H:%M:%S") + "################"
	data << "System_Info_Start"
	data << "Network_Info_Start"
	data << "Hostname:#{Host.hostname}"
	data << Host.ip_addr
	Host.info{ |h|
		data << h
	}
	data << "Network_Info_Stop"
	data << "OS_Info_Start"
	os = Uname.uname
	oslist = []
	for i in 0...os.length
		oslist << "#{os.members[i]}" + ":" + "#{os[i]}"
	end
	for i in 0...oslist.length
        	data << oslist[i]
	end
	data << "OS_Info_Stop"
	data << "User_Info_Start"
	data << Admin.get_login
	data << "User_Info_Stop"
	data << "CPU_Info_Start"
	CPU.processors{ |cs|
        	cs.members.each{ |m|
                	data << "#{m}:" + cs[m].to_s
        	}
	}
	data << "CPU_Info_Stop"
	data << "Filesystem_Start"
	Filesystem.mounts{ |mount|
	data << "Mount_Info_Start:#{mount.mount_point}"
	data << "Type:#{mount.mount_type}"
	data << "MTime:#{mount.mount_time}"
	data << "MPoint:#{mount.mount_point}"
	data << "MName:#{mount.name}"
	stat = Filesystem.stat(mount.mount_point)
	data << "BaseType:#{stat.base_type}"
	data << "Flags:#{stat.flags}"
	data << "FilesAvail:#{stat.files_available}"
	data << "BlockSize:#{stat.block_size}"
	data << "BlocksAvail:#{stat.blocks_available}"
	data << "Blocks:#{stat.blocks}"
	data << "MaxNames:#{stat.name_max}"
	data << "Path:#{stat.path}"
	data << "FSID:#{stat.filesystem_id}"
	data << "Files:#{stat.files}"
	data << "FragSize:#{stat.fragment_size}"
	data << "FilesFree:#{stat.files_free}"
	data << "BlocksFree:#{stat.blocks_free}"
	data << "Mount_Info_Stop:#{mount.mount_point}"
	}
	data << "Filesystem_Stop"
	data << "Process_Info_Start"
	ProcTable.ps{ |p|
        	data << "#{p.comm}:#{p.pid.to_s}"
	}
	data << "Process_Info_Stop"
	data << "System_Info_Stop"
	data << "####KEYKEYKEY##STOP##" + time.strftime("%Y-%m-%d-%H:%M:%S") + "################"
	data = data.join(",")
	return data
end

def parse_input(input)
	case input.strip
	
	when "status"
		return "this node is fine"
	when "dump"
		return system_info() 
	end
end	 


class Echo < EM::Connection
  def post_init()
	send_data("0987654321:auth?")
  end

  def receive_data(data)
        breakit = 0
	puts "got data"
	while breakit == 0
		puts data
		send_data(parse_input(data))
		breakit = 1
	end
  end
end

EM.run do
	puts "Attempting to connect"
        EM.connect("127.0.0.1", 10000, Echo)
end
end # ocra end
>>>>>>> parent of 20ff0b9... New arch, again, this time with sinatra and a web server
