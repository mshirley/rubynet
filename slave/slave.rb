#!/usr/bin/ruby

require 'rubygems'
require 'net/http'
require 'open4'
require 'rufus/scheduler'
require 'lib/load_sdata'
require 'lib/sjobs'
require 'lib/sremote_requests'

# Ocra is the ruby2exe app we're using.  this if loop prevents the compiler from executing it.
if not defined?(Ocra)

key, masterslist = load_db()
puts "masters in the list:"
puts masterslist


while 1 == 1

jobthreads = []
threads = []
jobqueue = []

masterslist.each { |master|
	jobqueue << pull_jobs(master, key)
}

sched_job(jobqueue, key)

puts "Waiting a bit" 
sleep rand(30) 




end
end # ocra end

#			Open4.popen4("echo #{job}") { |pid, stdin, stdout, stderr|
#				puts pid
#				puts stdout.read
#			}
#cookie = ""
#puts resp.response['set-cookie'].split('; ')[0]
#puts resp.response['set-cookie'].split('; ')[0]
#puts cookie
#while 1 == 1
#	sleep rand(15) 
#puts auth(host, port, nodeid, masterkey)
#puts register(host, port, nodeid, masterkey)
#end
