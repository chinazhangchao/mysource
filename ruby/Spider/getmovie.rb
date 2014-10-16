require './spider'

def eventAllComplete (multi, successList, failedList)
  puts "all complete"
  puts "success"
  puts successList.size
  puts "error"
  puts failedList.size
  puts failedList
  EventMachine.stop
end

def parseCategoryNode (multi, successList, failedList)
  puts "success"
  puts successList.size
  puts "error"
  puts failedList.size
  puts failedList
  if successList.size > 0
    linkList = []
    successList.each do |e|
      doc = Nokogiri::HTML(open(e.locPath))
      filtersdiv = doc.css('div#filters')
      typeArr = filtersdiv.css("div#type ul a")
      typeArr.each {|e| puts e.text}
      districtArr = filtersdiv.css("div#district ul a")
      districtArr.each {|e| puts e.text}
      eraArr = filtersdiv.css("div#era ul a")
      eraArr.each {|e| puts e.text}
    end
  end
  EventMachine.stop
end

parseDownLoadUrl("http://movie.douban.com/category/", "movie", "category.html", method(:parseCategoryNode))
