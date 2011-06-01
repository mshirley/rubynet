# node registration function
def register(id)
        if inventory_check(id) == "valid"
                return "ERROR: this node is already registered"
        else
                $inventory << id
                return "OK: this node has been registered"
        end
end

# this will check the global inventory array for a node id
def inventory_check(id)
        if $inventory.include?(id)
                return "valid"
        else
                return "invalid"
        end
end

# nothing here yet
def add_session(nodeip, node)


end

# reads a .job file for a specific node
def get_jobs(id)
        output = []
        if File.exist?("./files/jobs/#{id}.job")
                jobs = IO.readlines("./files/jobs/#{id}.job")
                "#{jobs}"
#               File.open("./files/jobs/#{id}.job", 'w') {|file| file.truncate(0)}
        else
                "no #{id}.job"
        end
end

def clear_jobs(id)
        file = "./files/jobs/#{id}.job"
        if File.exist?("./files/jobs/#{id}.job")
                File.open(file, 'w') { |file| file.truncate(0) }

        else
                "no #{id}.job"
        end
end

