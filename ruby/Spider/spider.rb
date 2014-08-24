require "open-uri"
require 'nokogiri'
require 'Open3'
require 'fileutils'

module DownLoadConfig
  MaxTryTime = 0
  MaxConcurrent = 20
  OverrideExist = false
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
    if !DownLoadConfig::OverrideExist && File.exist?(e.locPath)
      successList << Helper::LinkStruct.new(e.href, e.locPath)
    else
      threads << Thread.new {
        cmdLine = "curl --retry #{tryTimes} -L -o \"#{e.locPath}\" \"#{e.href}\""
        puts cmdLine
        Open3.popen3(cmdLine) {|stdin, stdout, stderr, wait_thr|
          exit_status = wait_thr.value
          if exit_status.exitstatus != 0
            mutexFailed.synchronize{
              failedList.push( Helper::LinkStruct.new(e.href, e.locPath))
            }
            puts "failed,exitstatus:#{exit_status.exitstatus},\
            \nhref:#{e.href}\nlocPath:#{e.locPath}\nerror msg:#{stderr.gets}\
            \nstdout:#{stdout.gets}"
          else
            mutexSucceed.synchronize{
              successList << Helper::LinkStruct.new(e.href, e.locPath)
            }
          end
          stdin.close
          stdout.close
          stderr.close
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

def batchDownList(downList, callBack = nil)
  failedList = []
  successList = []
  index = 0
  puts "total size:#{downList.size}"
  multiThreadDown(downList, successList, failedList, DownLoadConfig::MaxTryTime)
  puts "successList size:#{successList.size}"
  puts "failedList size:#{failedList.size}"
  callBack.call(successList, failedList) unless callBack.nil?
end

def parseDownLoadUrl(url, downDir, fileName, callBack = nil)
  downDir << "/" unless downDir.end_with?("/")
  FileUtils.mkdir_p(downDir) unless Dir.exist?(downDir)
  downList = []
  downList << Helper::LinkStruct.new(url, downDir + fileName)
  batchDownList(downList, callBack)
end
