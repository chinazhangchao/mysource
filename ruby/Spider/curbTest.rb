require 'curb'

#c = Curl::Easy.new("http://www.baidu.com")
c = Curl::Easy.new("http://www.lookmw.cn/")
c.follow_location = true
c.timeout=3
c.perform
puts "content_type:#{c.content_type}"
puts c.body.encoding
puts c.body.valid_encoding?
#out=File.new("lookmw.html", "w")
#out << c.body.encode(Encoding::UTF_8, Encoding::GB2312)
#puts c.head
puts "content_type:#{c.content_type}"

=begin
easy_options = {:follow_location => true}
multi_options = {:pipeline => true}

Curl::Multi.get('url1','url2','url3','url4','url5', easy_options, multi_options) do|easy|
  # do something interesting with the easy response
  puts easy.last_effective_url
end
=end
