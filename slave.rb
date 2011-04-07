#!/usr/bin/ruby
require 'socket'
require 'fileutils'
require 'rubygems'
require 'sys/host'
require 'sys/cpu'
require 'sys/filesystem'
require 'sys/proctable'
require 'sys/uname'
require 'sys/admin'
include Sys

if not defined?(Ocra)
data = []

data << "-- System Info Start --"
data << "-- Network Info Start --"
data << "Hostname: #{Host.hostname}"
data << Host.ip_addr 
Host.info{ |h|
	data << h
}
data << "-- Network Info Stop --"

data << "-- OS Info Start --"
os = Uname.uname
oslist = []
for i in 0...os.length
        oslist << os.members[i] + ": "
        oslist << os[i]
end
for i in 0...oslist.length
	data << oslist[i]
end
data << "-- OS Info Stop --"


data << "-- User Info Start --"
if RUBY_PLATFORM.match("linux")
	data << "Logged In User: " + Admin.get_login
	data << "Current Users:"
	Admin.users do |usr|
		data << usr.name
	end
else
	begin
		data << "Logged In User: " + Admin.get_login
		data << "Current Users:"
		Admin.users do |usr|
			data << usr.caption
		end
	rescue WIN32OLERuntimeError
	end
end
data << "-- User Info Stop --"


data << "-- CPU Info Start --"
CPU.processors{ |cs|
	cs.members.each{ |m|
		data << "#{m}: " + cs[m].to_s
	}
}
data << "-- CPU Info Stop --"

data << "-- Filesystem Start --"
Filesystem.mounts{ |mount|
data << "-- Mount Info Start for #{mount.mount_point} --"
data << "Type: #{mount.mount_type}"
data << "MTime: #{mount.mount_time}"
data << "MPoint: #{mount.mount_point}"
data << "MName: #{mount.name}"
stat = Filesystem.stat(mount.mount_point)
data << "Base Type: #{stat.base_type}"
data << "Flags: #{stat.flags}"
data << "Files Avail: #{stat.files_available}"
data << "Block Size: #{stat.block_size}"
data << "Blocks Avail: #{stat.blocks_available}"
data << "Blocks: #{stat.blocks}"
data << "Max Names: #{stat.name_max}"
data << "Path: #{stat.path}"
data << "FS ID: #{stat.filesystem_id}"
data << "Files: #{stat.files}"
data << "Frag Size: #{stat.fragment_size}"
data << "Files Free: #{stat.files_free}"
data << "Blocks Free: #{stat.blocks_free}"
data << "-- Mount Info Stop for #{mount.mount_point} --"
}
data << "-- Filesystem Stop --"


data << "-- Process Info Start --"
data << "-"
ProcTable.ps{ |p|
	data << "Name: #{p.comm}"
	data << "PID: #{p.pid.to_s}"
	data << "-"
}
data << "-- Process Info Stop --"
data << "-- System Info Stop --"

puts "---- HOST DATA ----"
puts data
data = data.join(",")

clientSession = TCPSocket.new( "localhost", 2008 )
puts "starting connection"
puts "putting key"
clientSession.puts "0987654321\n"

while !(clientSession.closed?) && (serverMessage = clientSession.gets)
	welcome = serverMessage
	puts welcome
	clientSession.puts "payload"
	payload = clientSession.gets
	puts "Payload recieved: #{payload}"
	clientSession.puts data 
	clientSession.close
end 
end
