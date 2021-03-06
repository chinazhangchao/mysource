require_relative 'spider.rb'

def allComplete(successList, failedList)
  puts "allComplete,failedList:#{failedList}"
end

def eventAllComplete(multi, successList, failedList)
  puts "success"
  puts multi.responses[:callback].size
  puts "error"
  puts multi.responses[:errback].size
  puts multi.responses[:errback].keys
  EventMachine.stop
end

def saveWYArticle(multi, successList, failedList)
  puts "success"
  puts multi.responses[:callback].size
  puts "error"
  puts multi.responses[:errback].size
  puts multi.responses[:errback].keys
  puts "get index complete"
  if successList.size > 0
    doc = Nokogiri::HTML(open(successList[0].locPath))
    listGroup=doc.css("ul.list-group")
    linkList = listGroup.css("a")
    puts "extrat href complete"

    downDir = "new/"
    FileUtils.mkdir_p(downDir) unless Dir.exist?(downDir)

    downList = []
    linkList.each do |link|
      href = link['href']
      locPath = downDir + link.content + ".html"
      downList.push( DownStruct::LinkStruct.new(href, locPath))
    end
    puts "down list complete"
    batchDownList(downList, :eventAllComplete)
  end
end

parseDownLoadUrl("http://www.yinwang.org/",\
 "wyIndex", "index.html", :saveWYArticle)
