require_relative 'spider.rb'
require 'Set'

def eventAllComplete(multi, successList, failedList)
  puts "all complete"
  puts "success"
  puts successList.size
  puts "error"
  puts failedList.size
  puts failedList
  EventMachine.stop
end

def downNodes(multi, successList, failedList, baseUrl, downDir, callback)
  puts "success"
  puts successList.size
  puts "error"
  puts failedList.size
  puts failedList
  puts "get index complete"
  if successList.size > 0
    linkList = []
    successList.each do |e|
      doc = Nokogiri::HTML(open(e.locPath))
      linkList.concat(doc.css("a"))
    end
    puts "extrat href complete"

    downDir << "/" unless downDir.end_with?("/")
    FileUtils.mkdir_p(downDir) unless Dir.exist?(downDir)

    downList = []
    setList = Set.new
    linkList.each do |link|
      href = link['href']
      next if href.nil? || !href.include?(".html")
      #process such as "scheme_2.html#SEC15"
      href = href[0, href.index(".html") + 5]
      #process such as "./preface.html"
      href = href[2..-1] if href.start_with?("./")
      next if !setList.add?(href)
      locPath = downDir + href
      downList.push( DownStruct::LinkStruct.new(baseUrl + href, locPath))
    end
    puts "down list complete,size:#{downList.size}"
    batchDownList(downList, callback)
  end
end

BaseUrl = "http://deathking.github.io/yast-cn/"
DownDir = "yast-cn"

def downSecondNode(multi, successList, failedList)
  downNodes(multi, successList, failedList, BaseUrl, DownDir, :eventAllComplete);
end

parseDownLoadUrl(BaseUrl, DownDir, "index.html", :downSecondNode)
