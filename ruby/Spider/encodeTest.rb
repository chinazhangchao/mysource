#f = File.new("tst.txt", "w:UTF_16LE")
=begin
f = File.new("tst.txt", "wt", external_encoding: Encoding::UTF_16LE)
f.write("a line")
f.close
=end
require 'rchardet'
def toUtf8(_string)
  cd = CharDet.detect(_string)      #用于检测编码格式  在gem rchardet9里
  if cd.confidence > 0.6
    _string.force_encoding(cd.encoding)
  end
  #_string.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
  _string.encode!(Encoding::UTF_8)
  return _string
end

f = File.new("gb2312.html", "rt", internal_encoding:Encoding::UTF_8, external_encoding: Encoding::GB2312)
#f = File.new("gb2312.html", "rt")
w = File.new("utf8.html", "wt" )
#10.times{w << f.readline.encode(Encoding::UTF_8)}
10.times{
  l = f.readline
  if l.index("美文")
    #w << l.encode(Encoding::GB2312)
    w << l.encode("GB2312")
  end
}
f.close
w.close
