require 'em-http-request'
require 'nokogiri'
require 'fileutils'
require 'set'
require File.expand_path('../../Util/helper', __FILE__)
require "addressable/uri"

module DownLoadConfig
  TimeOutLimit = 3*60 #3 minutes
  MaxTryTimes = 0
  MaxRedirects = 20
  MaxConcurrent = 0
  OverrideExist = false
end

class LinkStruct
  def initialize(href, locPath, httpMethod: :get, params: {}, extraData: nil)
    @href = href
    if @href.class == "".class
      @href = Addressable::URI.parse(href)
      @href.normalize!
    end
    @locPath = locPath
    @httpMethod = httpMethod
    @params = params
    @extraData = extraData
  end
  attr_accessor :href, :locPath, :httpMethod, :params, :extraData

end

module Spider

  @@converToUtf8 = false

  class << self

    def setHeaderOptions(optHash)
      @@headerOptions = optHash
    end

    def converToUtf8
      @@converToUtf8 = true
    end

    def eventMachineDown(linkStructList, callBack = nil)
      failedList = []
      successList = []
      puts "eventMachineDown callBack:#{callBack}"
      multi = EventMachine::MultiRequest.new
      noJob = true
      begTime = Time.now

      foreachPro = proc do |e|
        if !DownLoadConfig::OverrideExist && File.exist?(e.locPath)
          successList << e
        else
          noJob = false
          opt = {:redirects => DownLoadConfig::MaxRedirects}
          opt[:head] = @@headerOptions if defined? @@headerOptions
          if e.httpMethod == :post
            opt[:body] = e.params unless e.params.empty?
            w=EventMachine::HttpRequest.new(e.href).post opt
          else
            w=EventMachine::HttpRequest.new(e.href).get opt
          end

          w.callback {
            s = w.response_header.status
            locDir = File.dirname(e.locPath)
            FileUtils.mkdir_p(locDir) unless Dir.exist?(locDir)
            File.open(e.locPath, "w") do |f|
              if @@converToUtf8 == true
                f << Helper.toUtf8( w.response)
              else
                f << w.response
              end
            end
            successList << e
          }
          w.errback {
            puts "errback:#{w.response_header}"
            failedList << e
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
      downList << LinkStruct.new(url, downDir + fileName)
      EventMachine.run {
        index = 0
        puts "total size:#{downList.size}"
        begTime = Time.now
        eventMachineDown(downList, callBack)
        endTime = Time.now
      }
    end

    def evenMachineStartList(downList, callBack = nil)
      EventMachine.run {
        index = 0
        puts "total size:#{downList.size}"
        begTime = Time.now
        eventMachineDown(downList, callBack)
        endTime = Time.now
      }
    end

  end#self end
end#Spider end

def batchDownList(downList, callBack = nil)
  Spider.eventMachineDown(downList, callBack)
end

def evenMachineStartList(downList, callBack = nil)
  Spider.evenMachineStartList(downList, callBack)
end

def parseDownLoadUrl(url, downDir, fileName, callBack = nil)
  Spider.evenMachineStart(url, downDir, fileName, callBack)
end

class GetRelative

  def initialize(baseUrl,downDir,getDepth = 2)
    @getDepth = getDepth
    @baseUrl = baseUrl
    @downDir = downDir

    def downNodes (multi, successList, failedList, baseUrl, downDir, callBack)
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

          downList.push( LinkStruct.new(baseUrl + href, locPath))
        end
        puts "down list complete,size:#{downList.size}"
        batchDownList(downList, callBack)
      end
    end

    def downOtherNode (multi, successList, failedList)
      puts "downOtherNode"
      @getDepth = @getDepth - 1
      puts "depth:#{@getDepth}"
      if @getDepth <= 0
        downNodes(multi, successList, failedList, @baseUrl, @downDir, method(:eventAllComplete));
      else
        downNodes(multi, successList, failedList, @baseUrl, @downDir, method(:downOtherNode));
      end
    end

    def eventAllComplete (multi, successList, failedList)
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
      parseDownLoadUrl(@baseUrl, @downDir, indexFileName, method(:eventAllComplete))
    else
      parseDownLoadUrl(@baseUrl, @downDir, indexFileName, method(:downOtherNode))
    end
  end

  def self.Get(baseUrl,downDir,getDepth = 2)
    GetRelative.new(baseUrl,downDir,getDepth).start
  end
end #GetRelative
