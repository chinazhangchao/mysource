#This is a fork manager demo.You can use parallel-forkmanager in practical.
module ProcessConfig
  MaxNumber = 5
end

def startDemo( max = ProcessConfig::MaxNumber)
  total = 10

  ProcessConfig::MaxNumber.times { pid = fork { sleep 3 }
  puts "pid:#{pid}" }

  completeArr = []
  unRunNumber = total - ProcessConfig::MaxNumber
  while true
    begin
      pid, status = Process.wait2(-1)
      completeArr << status
      if unRunNumber > 0
        pid = fork{sleep 3}
        puts "pid:#{pid}"
        unRunNumber -= 1
        puts unRunNumber
      end
    rescue SystemCallError => e
      puts "SystemCallErro:#{e}"
      break
    rescue Exception => e
      puts "Exception:#{e}"
      break
    end
  end

  puts completeArr  
end
startDemo
