require "open-uri"
require 'nokogiri'
require 'Open3'

module Constant
  MaxTryTime = 5
end

module Helper
  LinkStruct = Struct.new(:href, :locPath)
end

def downLoad(url, locPath)
  parseHtml(url) do |data|
    open(locPath, "wb"){|f| f.write(data); f.close}
  end
end

def parseHtml(url)
    data = open(url){|f| f.read }
    yield data
end

def get_response_with_redirect(loc)
  begin
    r = Net::HTTP.get_response(URI(loc))
    i=0
    while r.code == "301"
      loc=r.header['location']
      puts "redirect location:#{r}"
      r = Net::HTTP.get_response(URI(loc))
      i+=1
      puts i
    end
  rescue URI::InvalidURIError => e
    URI(URI.escape(loc))
  end
  puts "code:#{r.code}"
end

def downUseCurl(href, locPath, failedList)
  puts "curl -L -o #{locPath} #{href}"
  Open3.popen3("curl -L -o #{locPath} #{href}") {|stdin, stdout, stderr, wait_thr|
  exit_status = wait_thr.value
  if exit_status.exitstatus != 0
    failedList.push( Helper::LinkStruct.new(href, locPath))
    puts "failed,href:#{href}\nlocPath:#{locPath}\nerror msg:#{stderr.gets}"
  end
}
end

def downWithStatus(href, locPath, failedList)
    begin
      downLoad(href, locPath)
      #puts "#{link.content}, #{link['href']}"
    rescue OpenURI::HTTPError => httpErr
      puts "http error:#{httpErr}\n href:#{href} \nlocPath:#{locPath}" 
      failedList.push( Helper::LinkStruct.new(href, locPath))
    rescue Exception => err
      puts "unkown error:#{err}"
    end
end

def saveArticle(data)
  doc=Nokogiri::HTML(data)
  listGroup=doc.css("ul.list-group")
  linkList = listGroup.css("a")

  failedList = []
  linkList.each do |link|
    href=link['href']
    locPath = "wy/"+link.content+".html"
    downUseCurl(href, locPath, failedList) unless File.exist?(locPath)
    puts "one complete"
  end
  tryTimes=0
  while !failedList.empty? && tryTimes < Constant::MaxTryTime
    puts "failed size:#{failedList.size}"
    fL = []
    failedList.each { |obj| downUseCurl(obj.href, obj.locPath, fL) }
    failedList = fL
    tryTimes+=1
  end
end

def wangyinArticle
  parseHtml("http://www.yinwang.org/"){|data| saveArticle(data)}
end
wangyinArticle
