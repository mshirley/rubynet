#!/usr/bin/ruby
require 'socket'
require 'fileutils'
require 'rubygems'
require 'sys/host'
require 'sys/cpu'
require 'sys/filesystem'
require 'sys/proctable'
require 'sys/uname'
include Sys

if not defined?(Ocra)

puts "-- System Info Start --"
puts "-- Network Info Start --"
puts "Hostname: #{Host.hostname}"
puts Host.ip_addr
Host.info{ |h|
        puts h
}
puts "-- Network Info Stop --"

puts "-- OS Info Start --"
os = Uname.uname
oslist = []
for i in 0...os.length
        oslist << os.members[i] + ": "
        oslist << os[i]
end
for i in 0...oslist.length
	puts oslist[i]
end
puts "-- OS Info Stop --"
puts "-- CPU Info Start --"
CPU.processors{ |cs|
	cs.members.each{ |m|
		puts "#{m}: " + cs[m].to_s
	}
}
puts "-- CPU Info Stop --"


puts "-- Filesystem Start --"
Filesystem.mounts{ |mount|
puts "-- Mount Info Start for #{mount.mount_point} --"
puts "Type: #{mount.mount_type}"
puts "MTime: #{mount.mount_time}"
puts "MPoint: #{mount.mount_point}"
puts "MName: #{mount.name}"
stat = Filesystem.stat(mount.mount_point)
puts "Base Type: #{stat.base_type}"
puts "Flags: #{stat.flags}"
puts "Files Avail: #{stat.files_available}"
puts "Block Size: #{stat.block_size}"
puts "Blocks Avail: #{stat.blocks_available}"
puts "Blocks: #{stat.blocks}"
puts "Max Names: #{stat.name_max}"
puts "Path: #{stat.path}"
puts "FS ID: #{stat.filesystem_id}"
puts "Files: #{stat.files}"
puts "Frag Size: #{stat.fragment_size}"
puts "Files Free: #{stat.files_free}"
puts "Blocks Free: #{stat.blocks_free}"
puts "-- Mount Info Stop for #{mount.mount_point} --"
}
puts "-- Filesystem Stop --"

puts "-- Process Info Start --"
puts "-"
ProcTable.ps{ |p|
	puts "Name: #{p.comm}"
	puts "PID: #{p.pid.to_s}"
	puts "-"
}
puts "-- Process Info Stop --"
puts "-- System Info Stop --"

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
	clientSession.puts "ok"

	clientSession.close
end 
end
