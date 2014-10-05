require "open-uri"
require 'em-http-request'
require 'nokogiri'
require 'Open3'
require 'fileutils'
require 'curb'
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
  ProcessInfo = Struct.new(:stdIn, :stdOut, :stdErr, :waitThr)
end

module Spider

  class << self
    def getUrlData(url)
      data = open(url){|f| f.read }
      yield data if block_given?
    end

    def downLoad(url, locPath)
      getUrlData(url) do |data|
        open(locPath, "wb"){|f| f.write(data); f.close}
      end
    end

    def multiProcessDown(linkStructList, successList, failedList)
      threads = []
      mutexFailed = Mutex.new
      mutexSucceed = Mutex.new
      linkStructList.each do |e|
        pInfo = DownStruct::ProcessInfo.new
        if !DownLoadConfig::OverrideExist && File.exist?(e.locPath)
          successList << DownStruct::LinkStruct.new(e.href, e.locPath)
        else
          threads << Thread.new {
            cmdLine = "curl -m #{DownLoadConfig::TimeOutLimit} \
            --retry #{DownLoadConfig::MaxTryTimes} -L -o \"#{e.locPath}\" \"#{e.href}\""
            puts cmdLine
            Open3.popen3(cmdLine) {|stdin, stdout, stderr, wait_thr|
              exit_status = wait_thr.value
              if exit_status.exitstatus != 0
                mutexFailed.synchronize{
                  failedList.push( DownStruct::LinkStruct.new(e.href, e.locPath))
                }
                puts "failed,exitstatus:#{exit_status.exitstatus},\
                \nhref:#{e.href}\nlocPath:#{e.locPath}\nerror msg:#{stderr.gets}\
                \nstdout:#{stdout.gets}"
              else
                mutexSucceed.synchronize{
                  successList << DownStruct::LinkStruct.new(e.href, e.locPath)
                }
              end
            }
          }
          if threads.size >= DownLoadConfig::MaxConcurrent
            puts "threads size:#{threads.size}"
            threads.each { |thr| thr.join }
            threads.clear
          end
        end
      end
      puts "threads size:#{threads.size}"
      threads.each { |thr| thr.join }
    end

    def multiThreadDown(linkStructList, successList, failedList)
      threads = []
      mutexFailed = Mutex.new
      mutexSucceed = Mutex.new
      linkStructList.each do |e|
        pInfo = DownStruct::ProcessInfo.new
        if !DownLoadConfig::OverrideExist && File.exist?(e.locPath)
          successList << DownStruct::LinkStruct.new(e.href, e.locPath)
        else
          threads << Thread.new {
            c = Curl::Easy.new(e.href) do|curl|
              curl.follow_location = true
              curl.timeout =DownLoadConfig::TimeOutLimit
              curl.on_success do |c|
                begin
                  File.new(e.locPath, "w") << toUtf8(curl.body)
                  puts "#{e.locPath} succeed"
                  mutexSucceed.synchronize{
                    successList << DownStruct::LinkStruct.new(e.href, e.locPath)
                  }
                rescue Exception => e
                  puts e
                end
              end
              curl.on_failure do |c,r|
                puts "#{e.locPath} failed"
                puts "reason:#{r}"
                mutexFailed.synchronize{
                  failedList.push( DownStruct::LinkStruct.new(e.href, e.locPath))
                }
              end
            end
            c.perform
          }
          if threads.size >= DownLoadConfig::MaxConcurrent
            puts "threads size:#{threads.size}"
            threads.each { |thr| thr.join }
            threads.clear
          end
        end
      end
      puts "threads size:#{threads.size}"
      threads.each { |thr| thr.join }
    end

    def curlMultiDown(linkStructList, successList, failedList)
      #mutexFailed = Mutex.new
      #mutexSucceed = Mutex.new
      m = Curl::Multi.new
      linkStructList.each do |e|
        if !DownLoadConfig::OverrideExist && File.exist?(e.locPath)
          #mutexSucceed.synchronize{
          successList << DownStruct::LinkStruct.new(e.href, e.locPath)
          #}
        else
          c = Curl::Easy.new(e.href) do|curl|
            curl.follow_location = true
            curl.timeout =DownLoadConfig::TimeOutLimit
            curl.on_success do |c|
              begin
                File.new(e.locPath, "w") << toUtf8(curl.body)
                #mutexSucceed.synchronize{
                puts "#{e.locPath} succeed"
                successList << DownStruct::LinkStruct.new(e.href, e.locPath)
                #}
              rescue Exception => e
                puts e
              end
            end
            curl.on_failure do |c,r|
              #mutexFailed.synchronize{
              puts "#{e.locPath} failed"
              puts "reason:#{r}"
              failedList.push( DownStruct::LinkStruct.new(e.href, e.locPath))
              #}
            end
          end
          m.add(c)
        end
        m.perform
      end
    end

    def batchDownList(downList, callBack = nil)
      failedList = []
      successList = []
      index = 0
      puts "total size:#{downList.size}"
      begTime = Time.now
      #multiThreadDown(downList, successList, failedList)
      #multiProcessDown(downList, successList, failedList)
      endTime = Time.now
      puts "use time:#{endTime-begTime} seconds"
      puts "successList size:#{successList.size}"
      puts "failedList size:#{failedList.size}"
      puts "batchDownList callBack:#{callBack}"
      callBack.call(successList, failedList) unless callBack.nil?
    end

    def eventBatchDownList(downList, callBack = nil)
      puts "eventBatchDownList"
      failedList = []
      successList = []
      eventMachineDown(downList, successList, failedList, callBack)
    end

    def parseDownLoadUrl(url, downDir, fileName, callBack = nil)
      downDir << "/" unless downDir.end_with?("/")
      FileUtils.mkdir_p(downDir) unless Dir.exist?(downDir)
      downList = []
      downList << DownStruct::LinkStruct.new(url, downDir + fileName)
      batchDownList(downList, callBack)
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
        puts "use time:#{endTime-begTime} seconds"
        puts "successList size:#{successList.size}"
        puts "failedList size:#{failedList.size}"
      }
    end

  end#self end
end#Spider end

def batchDownList(downList, methodName = nil, objectName = nil)
  Spider.eventBatchDownList(downList, Helper.formMethod(methodName, objectName))
end

def parseDownLoadUrl(url, downDir, fileName, methodName = nil, objectName = nil)
  Spider.evenMachineStart(url, downDir, fileName, Helper.formMethod(methodName, objectName))
end
