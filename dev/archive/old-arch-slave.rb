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
require 'zlib'
require 'digest/md5'
require 'base64'
include Sys
if not defined?(Ocra)
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
compString = Zlib::Deflate.deflate data.to_s
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
	clientSession.puts compString 
	clientSession.close
end 
end
