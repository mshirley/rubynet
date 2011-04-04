#!/usr/bin/ruby
require 'socket'
require 'fileutils'

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
