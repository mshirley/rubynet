require 'rubygems'

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__),"..", "..", "msf3", "msf3"))

require 'msf/base'

asdf = ["exploit/multi/handler"]
 
framework = Msf::Simple::Framework.create
 
begin

# Create the module instance.
mod = framework.modules.create(asdf.shift)
 
     # Dump the module’s information in readable text format.
     puts Msf::Serializer::ReadableText.dump_module(mod)
 rescue
     puts "Error: #{$!}\n\n#{$@.join("\n")}" 
 end
