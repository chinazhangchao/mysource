
=begin
begin
	inputFile=File.new("dl.txt", "r")
rescue Exception => e
	puts e.message
end
=end

=begin
cmd = "curl -f -L -k -o D:/test.jpg http://b.hiphotos.baidu.com/album/w%3D2048/sign=50629bde9922720e7bcee5fa4ff30b46/5243fbf2b2119313e9ebc10c64380cd790238de5.jpg"

begin
	f = IO.popen(cmd)
	puts f.readlines
	pid,status=Process.wait2(f.pid)
	#puts "pid:#{pid}"
	puts "exit code:#{status.exitstatus}"
rescue Exception => e
	puts e.message
end
=end

require "open-uri"

def download(url, locPath)
	data = open(url){|f| f.read }
	open("D:/test.jpg", "wb"){|f| f.write(data); f.close}
end

durl = "http://b.hiphotos.baidu.com/album/w%3D2048/sign=50629bde9922720e7bcee5fa4ff30b46/5243fbf2b2119313e9ebc10c64380cd790238de5.jpg"
loc1 = "D:/test.jpg"
download(durl, loc1)