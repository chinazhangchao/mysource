require 'em-http-request'
require 'nokogiri'
require 'fileutils'
require 'set'
require_relative '../Util/helper'

module DownLoadConfig
  TimeOutLimit = 3*60 #3 minutes
  MaxTryTimes = 0
  MaxRedirects = 20
  MaxConcurrent = 0
  OverrideExist = false
end

module DownStruct
  LinkStruct = Struct.new(:href, :locPath)
end

module Spider

  class << self

    def eventBatchDownList(downList, callBack = nil)
      puts "eventBatchDownList"
      failedList = []
      successList = []
      eventMachineDown(downList, successList, failedList, callBack)
    end

    def eventMachineDown(linkStructList, successList, failedList, callBack = nil)
      puts "eventMachineDown callBack:#{callBack}"
      multi = EventMachine::MultiRequest.new
      noJob = true
      begTime = Time.now

      foreachPro = proc do |e|
        if !DownLoadConfig::OverrideExist && File.exist?(e.locPath)
          successList << DownStruct::LinkStruct.new(e.href, e.locPath)
        else
          noJob = false
          w=EventMachine::HttpRequest.new(e.href).get :redirects => DownLoadConfig::MaxRedirects
          w.callback {
            s = w.response_header.status
            File.new(e.locPath, "w") << Helper.toUtf8( w.response)
            successList << DownStruct::LinkStruct.new(e.href, e.locPath)
          }
          w.errback {
            s = w.response_header.status
            puts "errback:#{s}"
            failedList.push( DownStruct::LinkStruct.new(e.href, e.locPath))
          }
          multi.add e.locPath, w
        end
      end

      emForeachPro = proc do |e, iter|
        foreachPro.call(e)
        iter.next
      end

      cb = Proc.new do
        endTime = Time.now
        puts "use time:#{endTime-begTime} seconds"
        if callBack.nil?
          EventMachine.stop
        else
          callBack.call(multi, successList, failedList)
        end
      end

      afterProc = proc {
        if noJob #没有任务直接调回调
          cb.call
        else
          multi.callback &cb
        end
      }

      if DownLoadConfig::MaxConcurrent <= 0
        linkStructList.each &foreachPro
        afterProc.call
      else
        EM::Iterator.new(linkStructList, DownLoadConfig::MaxConcurrent).each(emForeachPro, afterProc)
      end
    end

    def evenMachineStart(url, downDir, fileName, callBack = nil)
      downDir << "/" unless downDir.end_with?("/")
      FileUtils.mkdir_p(downDir) unless Dir.exist?(downDir)
      downList = []
      downList << DownStruct::LinkStruct.new(url, downDir + fileName)
      EventMachine.run {
        failedList = []
        successList = []
        index = 0
        puts "total size:#{downList.size}"
        begTime = Time.now
        eventMachineDown(downList, successList, failedList, callBack)
        endTime = Time.now
      }
    end

  end#self end
end#Spider end

def batchDownList(downList, callbackPro)
  Spider.eventBatchDownList(downList, callbackPro)
end

def parseDownLoadUrl(url, downDir, fileName, callbackPro)
  puts callbackPro
  Spider.evenMachineStart(url, downDir, fileName, callbackPro)
end

class GetRelative

  def initialize(baseUrl,downDir,getDepth = 2)
    @getDepth = getDepth
    @baseUrl = baseUrl
    @downDir = downDir

    @downNodes = proc do |multi, successList, failedList, baseUrl, downDir, callback|
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

    @downOtherNode = proc do |multi, successList, failedList|
      puts "downOtherNode"
      @getDepth = @getDepth - 1
      puts "depth:#{@getDepth}"
      if @getDepth <= 0
        @downNodes.call(multi, successList, failedList, @baseUrl, @downDir, @eventAllComplete);
      else
        @downNodes.call(multi, successList, failedList, @baseUrl, @downDir, @downOtherNode);
      end
    end

    @eventAllComplete = proc do |multi, successList, failedList|
      puts "all complete"
      puts "success"
      puts successList.size
      puts "error"
      puts failedList.size
      puts failedList
      EventMachine.stop
    end
  end

  attr_writer :getDepth,:baseUrl,:downDir

  def start
    indexFileName = "index.html"
    #http://www.ccs.neu.edu/home/dorai/t-y-scheme/t-y-scheme-Z-H-1.html
    unless @baseUrl.end_with?("/")
      i = @baseUrl.rindex"/"
      indexFileName = @baseUrl[i+1 .. -1]
    end

    @getDepth = @getDepth - 1
    puts @getDepth
    if @getDepth <= 0
      parseDownLoadUrl(@baseUrl, @downDir, indexFileName, @eventAllComplete)
    else
      parseDownLoadUrl(@baseUrl, @downDir, indexFileName, @downOtherNode)
    end
  end

  def self.Get(baseUrl,downDir,getDepth = 2)
    GetRelative.new(baseUrl,downDir,getDepth).start
  end
end #GetRelative
