#!/usr/bin/ruby
require 'socket'

clientSession = TCPSocket.new( "localhost", 2008 )
puts "starting connection"
puts "putting key"
clientSession.puts "0987654321\n"
 while !(clientSession.closed?) &&
 (serverMessage = clientSession.gets)
  puts serverMessage
  if serverMessage.include?("Goodbye")
   puts "log: closing connection"
   clientSession.close
  end
 end 
