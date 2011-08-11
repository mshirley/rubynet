def load_db()
        key = ""
        masterkey = ""
        mlist = []
        configs = ["node.dat", "masters.dat"]

        configs.each { |i|
        if File.exists?(i) && i == "masters.dat"
                puts "Masters list found, loading..."
                masterslist = File.open(i, "r")
                puts "Masters list loaded"
                masterslist.each do |line|
                        mlist <<= line.chomp
                end
        else if !File.exist?(i) && i == "masters.dat"
                puts "Masters list not found, creating..."
                masterslist = File.new("masters.dat", "w")
                masterslist.puts("localhost:4563:1234567890")
                end
        end
        puts i
        if File.exists?(i) && i == "node.dat"
                puts "Node configuration found, loading..."
                nodedata = File.open(i, "r")
                puts "Node configuration loaded"
                nodedata.each do |line|
                        key = line.chomp
                end
                puts "Key is #{key}"
        else if !File.exist?(i) && i == "node.dat"
                puts "Node configuration not found, creating..."
                nodedata = File.new("node.dat", "w")
                o = [('a'..'z'),('A'..'Z'),('0'..'9')].map{ |i| i.to_a }.flatten
                key = (0..50).map { o[rand(o.length)] }.join
                nodedata.puts(key)
                puts "Generating key... #{key}"
                nodedata.close
                end
        end
        }
        return key, mlist
end
