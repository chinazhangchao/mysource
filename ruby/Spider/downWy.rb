require_relative 'spider.rb'

def saveWYArticle(successList, failedList)
  puts "get index complete"
  if successList.size > 0
    doc = Nokogiri::HTML(open(successList[0].locPath))
    listGroup=doc.css("ul.list-group")
    linkList = listGroup.css("a")
    puts "extrat href complete"

    downList = []
    linkList.each do |link|
      href = link['href']
      locPath = "new/" + link.content + ".html"
      downList.push( Helper::LinkStruct.new(href, locPath))
    end
    puts "down list complete"
    batchDownList(downList)
  end
end

parseDownLoadUrl("http://www.yinwang.org/",\
 "wyIndex", "index.html", self.method(:saveWYArticle))
