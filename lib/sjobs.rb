def getjobs(host, port, key, masterkey)
        response = fetch(host, port, "/node/#{key}/getjobs/#{masterkey}/optional2")
        return response
end

def clearjobs(host, port, key, masterkey)
        response = fetch(host, port, "/node/#{key}/clearjobs/#{masterkey}/optional2")
        return response
end

def processjobs(job)
        jobresult = ""
        jobcmd = job.split(":")[1]
        case jobcmd
        when "system"
                puts "got system"
        when "reverse"
        #       reverse(job)
        when "promote"
                puts "got promote"
        when "demote"
                puts "got demote"
        end
        return jobresult

end

def pull_jobs(master, key)
jobthreads = []
threads = []
jobqueue = []

#masterslist.each { |master|
        # mmmmm multithreading!
#        threads << Thread.new {
        puts "connecting to master: #{master}"
        host = master.split(":")[0]
        port = master.split(":")[1]
        masterkey = master.split(":")[2]
        begin
        regresp = init(host, port, key, masterkey) # authresp
        
        if !regresp.respond_to?("body")
                puts regresp 
                # log, retry
        else
                puts "Pulling jobs"
                jobqueue = getjobs(host, port, key, masterkey).body.to_a
                jobqueue = jobqueue.flatten.uniq
                puts "Clearing job file"
                clearjobs(host, port, key, masterkey)
                if jobqueue.length == 0
                        puts "emtpy job queue"
#               else
#                       jobqueue.each { |job|
#                               puts "Executing job: #{job}"
#                               jobresult = processjob(job)
#                       }
#                       puts "Clearing job file"
#                       clearjobs(host, port, key, masterkey)
                end
        end
        rescue
        end
#        }
#        threads.each { |aThread| aThread.join }
#}
return jobqueue
end
