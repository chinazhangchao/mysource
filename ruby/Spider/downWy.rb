require_relative 'spider.rb'

def allComplete(successList, failedList)
  puts "allComplete,successList:\n#{successList}\n,failedList:#{failedList}"
end

def saveWYArticle(successList, failedList)
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
      downList.push( Helper::LinkStruct.new(href, locPath))
    end
    puts "down list complete"
    batchDownList(downList, self.method(:allComplete))
  end
end

parseDownLoadUrl("http://www.yinwang.org/",\
 "wyIndex", "index.html", self.method(:saveWYArticle))
