require 'curb'
require_relative 'spider.rb'
require 'rchardet'
def toUtf8(_string)
  cd = CharDet.detect(_string)      #用于检测编码格式  在gem rchardet9里
  if cd["confidence"] > 0.6
    _string.force_encoding(cd["encoding"])
  end
  #_string.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
  _string.encode!(Encoding::UTF_8)
  return _string
end

def test
  c2 = Curl::Easy.new("http://www.baidu.com")
  c1 = Curl::Easy.new("http://www.lookmw.cn/")
  c1.follow_location = true
  c1.timeout=3
  #c1.perform
  m = Curl::Multi.new

  m.add( c1 )
  m.add( c2 )

  m.perform
  puts "c1 content_type:#{c1.content_type}"
  puts c1.response_code
  #out=File.new("lookmw.html", "w")
  #out << c1.body.encode(Encoding::UTF_8, Encoding::GB2312)
  #puts c1.head
  puts "c2 content_type:#{c2.content_type}"
end

def test_remote_requests
  downList = []
  href = "http://www.baidu.com"
  locPath = "baidu.html"
  downList.push( Helper::LinkStruct.new(href, locPath))
  downList.push(Helper::LinkStruct.new("http://www.lookmw.cn/","mw.html"))
  m = Curl::Multi.new
  downList.each do |link|
    c = Curl::Easy.new(link.href) do|curl|
      curl.follow_location = true
      curl.timeout=3
      curl.on_success{ File.new(link.locPath, "w") << toUtf8(curl.body)}
    end
    m.add(c)
  end

  m.perform
end
test_remote_requests
