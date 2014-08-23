require "open-uri"
require 'nokogiri'
require 'Open3'

module DownLoadConfig
  MaxTryTime = 2
  MaxConcurrent = 20
end

module Helper
  LinkStruct = Struct.new(:href, :locPath)
  ProcessInfo = Struct.new(:stdIn, :stdOut, :stdErr, :waitThr)
end

def getUrlData(url)
    data = open(url){|f| f.read }
    yield data
end

def downLoad(url, locPath)
  getUrlData(url) do |data|
    open(locPath, "wb"){|f| f.write(data); f.close}
  end
end

def multiThreadDown(linkStructList, successList, failedList, tryTimes = 0)
  threads = []
  mutexFailed = Mutex.new
  mutexSucceed = Mutex.new
  linkStructList.each do |e|
    pInfo = Helper::ProcessInfo.new
    unless File.exist?(e.locPath)
      threads << Thread.new {
        cmdLine = "curl --retry #{tryTimes} -L -o \"#{e.locPath}\" \"#{e.href}\""
        puts cmdLine
        Open3.popen3(cmdLine) {|stdin, stdout, stderr, wait_thr|
          exit_status = wait_thr.value
          if exit_status.exitstatus != 0
            mutexFailed.synchronize{failedList.push( Helper::LinkStruct.new(e.href, e.locPath))}
            puts "failed,exitstatus:#{exit_status.exitstatus},\nhref:#{e.href}\nlocPath:#{e.locPath}\nerror msg:#{stderr.gets}"
          else
            mutexSucceed.synchronize{successList << Helper::LinkStruct.new(e.href, e.locPath)}
          end
          stdin.close
          stdout.close
          stderr.close
        }
      }
    end
  end
  puts "threads size:#{threads.size}"
  threads.each { |thr| thr.join }
end

def batchDownList(downList)
  failedList = []
  successList = []
  index = 0
  puts "total size:#{downList.size}"

  proList = downList[index, DownLoadConfig::MaxConcurrent]
  while proList!=nil && proList.size > 0
    multiThreadDown(proList, successList, failedList)
    index += DownLoadConfig::MaxConcurrent
    proList = downList[index, DownLoadConfig::MaxConcurrent]
  end

  puts "successList size:#{successList.size}"
  puts "failedList size:#{failedList.size}"
end

def saveArticleConcurrent(data, downDir, filePostFix)
  puts "get data complete"
  doc=Nokogiri::HTML(data)
  listGroup=doc.css("ul.list-group")
  linkList = listGroup.css("a")
  puts "extrat href complete"

  downList = []
  linkList.each do |link|
    href=link['href']
    locPath = downDir+link.content+filePostFix
    downList.push( Helper::LinkStruct.new(href, locPath))
  end
  puts "down list complete"
  batchDownList(downList)
end

def wangyinArticle
  getUrlData("http://www.yinwang.org/"){|data| saveArticleConcurrent(data, "new/", ".html")}
end
wangyinArticle
