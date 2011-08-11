def getjobs(host, port, key, masterkey)
        response = fetch(host, port, "/node/#{key}/getjobs/#{masterkey}/optional2")
        return response
end

def clearjobs(host, port, key, masterkey)
        response = fetch(host, port, "/node/#{key}/clearjobs/#{masterkey}/optional2")
        return response
end

def processjobs(job, key)
        jobresult = ""
        jobcmd = job.split(":")[1]

        case jobcmd
        when "system_info"
        	host = job.split(":")[4].strip
		puts "Job host is #{host}"
        	port = job.split(":")[5].strip
		puts "Job port is #{port}"
		jobresult = system_info()
		upload(host, port, key, jobresult, "system_info") 
	when "send_file"
		host = job.split(":")[4].strip
		puts "Job host is #{host}"
		port = job.split(":")[5].strip
		puts "Job port is #{port}"
		fileinfo = job.split(":")[6].strip
		jobresult = pull_file(fileinfo) 
		upload(host, port, key, jobresult, "send_file")
	when "reverse"
        #       reverse(job)
        when "promote"
                puts "got promote"
        when "demote"
                puts "got demote"
        end
        return jobresult

end

def sched_job(jobqueue, key)
	scheduler = Rufus::Scheduler.start_new
	jobqueue = jobqueue.flatten.uniq
	jobqueue.each { |job|
	        puts job
	        puts "Scheduling job"
	        if !job.nil?
	                scheduler.in '2s' do
	                        puts "Executing job: #{job}"
				processjobs(job, key)
				puts "Job complete: #{job}"
	                end
        end
}
end


def pull_jobs(master, key)
jobthreads = []
threads = []
jobqueue = []

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
                end
        end
        rescue
        end
#        }
#        threads.each { |aThread| aThread.join }
#}
return jobqueue
end
