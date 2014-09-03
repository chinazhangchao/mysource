require 'rchardet'

def toUtf8(_string)
  case _string.encoding 
  when Encoding::UTF_8 #utf-8不做处理
  when Encoding::ASCII-8BIT
    cd = CharDet.detect(_string)
    if cd["confidence"] > 0.6
      _string.force_encoding(cd["encoding"])
    end
    #_string.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
    _string.encode!(Encoding::UTF_8)
  else
    _string.encode!(Encoding::UTF_8)
  end

  return _string
end

def formMethod(methodNameSymbol, objectName)
  if methodNameSymbol == nil
    return nil
  elsif objectName == nil
    method(methodNameSymbol)
  else
    return objectName.method(methodNameSymbol)
  end
end
