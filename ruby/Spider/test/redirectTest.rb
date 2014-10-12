require 'Net/http'
require_relative '../Util/helper'

def redirectProcess(res)
  case res
  when Net::HTTPRedirection
    puts "redirct"
    l=res['location']
    u=Helper.stringToUri(l)
    r=Net::HTTP.get_response(u)
    return redirectProcess(r)
  else
    puts res.header
  end
  return res
end

url="http://yinwang.org/blog-cn/2013/07/06/PyDiff-Python%E7%BB%93%E6%9E%84%E5%8C%96%E7%A8%8B%E5%BA%8F%E6%AF%94%E8%BE%83%E5%B7%A5%E5%85%B7"
res=Net::HTTP.get_response(Helper.stringToUri(url))
redirectProcess(res)
