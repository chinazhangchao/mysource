require_relative 'spider.rb'
require 'Set'

$getDepth = 2;
BaseUrl = "http://www.ccs.neu.edu/home/dorai/t-y-scheme/t-y-scheme-Z-H-1.html"
DownDir = "t-y-scheme/"

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
      unless baseUrl.end_with?("/")
        i = baseUrl.rindex"/"
        baseUrl = baseUrl[0..i]
      end

      #process such as "http://www.ccs.neu.edu/~dorai"
      next if href.start_with?("http:") || href.start_with?("https:")

      locPath = downDir + href

      downList.push( DownStruct::LinkStruct.new(baseUrl + href, locPath))
    end
    puts "down list complete,size:#{downList.size}"
    batchDownList(downList, callback)
  end
end

def downOtherNode(multi, successList, failedList)
  puts "downOtherNode"
  $getDepth = $getDepth - 1
  puts "depth:#{$getDepth}"
  if $getDepth <= 0
    downNodes(multi, successList, failedList, BaseUrl, DownDir, :eventAllComplete);
  else
    downNodes(multi, successList, failedList, BaseUrl, DownDir, :downOtherNode);
  end
end

indexFileName = "index.html"
#http://www.ccs.neu.edu/home/dorai/t-y-scheme/t-y-scheme-Z-H-1.html
unless BaseUrl.end_with?("/")
  i = BaseUrl.rindex"/"
  indexFileName = BaseUrl[i+1 .. -1]
end

parseDownLoadUrl(BaseUrl, DownDir, indexFileName, :downOtherNode)
