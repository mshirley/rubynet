def pull_jobs(masterslist, key)
jobthreads = []
threads = []
jobqueue = []

masterslist.each { |master|
        # mmmmm multithreading!
        threads << Thread.new {
#       puts "waiting for a sec or so"
#       sleep(rand(15))
        puts "connecting to master: #{master}"
        host = master.split(":")[0]
        port = master.split(":")[1]
        masterkey = master.split(":")[2]
        begin
        regresp = init(host, port, key, masterkey) # authresp
        
#       if !authresp.respond_to?("body") or 
        if !regresp.respond_to?("body")
                puts regresp 
                # log, retry
        else
                puts "Pulling jobs"
                jobqueue << getjobs(host, port, key, masterkey).body.to_a
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
        }
        threads.each { |aThread| aThread.join }
}
return jobqueue
end

