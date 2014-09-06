require 'em-http-request'

urls=["http://www.baidu.com", "http://www.bing.com", "http://www.yinwang.org/", "http://yinwang.org/blog-cn/2014/09/04/female-fans", "http://yinwang.org/blog-cn/2014/08/29/faq", "http://yinwang.org/blog-cn/2014/08/11/genius"]
urls2=["http://www.fdsfs.com", "http://www.abc.com"]
EventMachine.run {
  begTime = Time.now
      multi = EventMachine::MultiRequest.new
      multi.callback {
        puts "all complete"
        endTime = Time.now
        puts "use time:#{endTime - begTime}"
        EventMachine.stop
      }
  EM::Iterator.new(urls, 1).each { |url,iter|
  puts url
  puts iter
  w=EventMachine::HttpRequest.new(url).get :redirects =>20
  w.callback {
    s = w.response_header.status
    puts "response status:#{s}"
  }
          multi.add iter, w
  iter.next
}
=begin
EM::Iterator.new(urls2, 10).each( proc { |url,iter|
  puts url
  w=EventMachine::HttpRequest.new(url).get :redirects =>20
  w.callback {
    s = w.response_header.status
    puts "response status:#{s}"
  }
  iter.next
}, proc {puts "second done"; EventMachine.stop})
=end
}
