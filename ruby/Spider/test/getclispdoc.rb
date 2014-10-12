require_relative 'spider.rb'
require 'Set'

def eventAllComplete(multi, successList, failedList)
  puts "all complete"
  #puts multi.responses[:callback]
  puts "success"
  puts multi.responses[:callback].size
  puts "error"
  puts multi.responses[:errback].size
  puts multi.responses[:errback].keys
  EventMachine.stop
end

def downOtherNode(multi, successList, failedList)
  puts "success"
  puts multi.responses[:callback]
  puts multi.responses[:callback].size
  puts "error"
  puts multi.responses[:errback].size
  puts multi.responses[:errback].keys
  puts "get index complete"
  if successList.size > 0
    doc = Nokogiri::HTML(open(successList[0].locPath))
    linkList = doc.css("a")
    puts "extrat href complete"

    downDir = "clispdoc/"
    FileUtils.mkdir_p(downDir) unless Dir.exist?(downDir)

    downList = []
    setList = Set.new
    linkList.each do |link|
      href = link['href']
      next if href.nil? || !href.end_with?(".html") || !setList.add?(href)
      locPath = downDir + href
      downList.push( DownStruct::LinkStruct.new("https://www.cs.cmu.edu/Groups/AI/html/cltl/clm/" + href, locPath))
    end
    puts "down list complete"
    batchDownList(downList, :eventAllComplete)
  end
end

parseDownLoadUrl("https://www.cs.cmu.edu/Groups/AI/html/cltl/clm/index.html",\
 "clispdoc", "index.html", :downOtherNode)
