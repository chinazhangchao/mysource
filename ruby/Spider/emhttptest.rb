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

EventMachine.run {
=begin
  http = EventMachine::HttpRequest.new("http://www.yinwang.org/").get

  http.errback { p 'Uh oh'; EM.stop }
  http.callback {
    p http.response_header.status
    p http.response_header
    p http.response

    EventMachine.stop
  }
=end

}
