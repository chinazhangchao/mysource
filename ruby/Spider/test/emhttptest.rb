require 'em-http-request'
require_relative '../Util/helper'

def eventMachineDown(linkStructList, successList, failedList)
  multi = EventMachine::MultiRequest.new
  linkStructList.each do |e|
    if !DownLoadConfig::OverrideExist && File.exist?(e.locPath)
      successList << Helper::LinkStruct.new(e.href, e.locPath)
    else
      w=EventMachine::HttpRequest.new(e.href).get
      w.callback {
        puts w.response.class
        puts w.response.encoding
        File.new(e.locPath, "w") << toUtf8( w.response)
      }
      multi.add e.locPath, w
    end
  end
  multi.callback do
    puts "callback"
    puts multi.responses[:callback].size
    puts "errback"
    puts multi.responses[:errback].size
    puts multi.responses[:errback].keys
    EventMachine.stop
  end
end

def wf(http,i)
    fn = "#{i}.html"
    http.callback {
      p http.response_header.status
      p http.response_header
      puts fn
      File.new(fn , "w") << Helper.toUtf8( http.response)
    }
end

EventMachine.run {
  #=begin
  #http = EventMachine::HttpRequest.new("http://www.yinwang.org/").get
  multi = EventMachine::MultiRequest.new
  #conn = EventMachine::HttpRequest.new("http://caipiao.jd.com/notice/betResult_noticeInfo.html") 
  for i in 1..5
    #http = conn.post :keepalive => true, :body => {"issueQuery.lotteryType" => 1, "issueQuery.beginTimeTo" => "2014-09-02 20:59:00", "page" => i}
  conn = EventMachine::HttpRequest.new("http://caipiao.jd.com/notice/betResult_noticeInfo.html") 
    http = conn.post  :body => {"issueQuery.lotteryType" => 1, "issueQuery.beginTimeTo" => "2014-09-02 20:59:00", "page" => i}

    http.errback {
      p 'Uh oh'
      p http.response_header.status
      p http.response_header
    }
    wf(http, i)
    multi.add "#{i}.html", http
  end

  multi.callback {
    puts "all complete"
    EventMachine.stop
  }
  #=end
}
