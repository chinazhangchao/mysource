require 'rchardet'

def toUtf8(_string)
  return _string if _string.encoding == Encoding::UTF_8
  cd = CharDet.detect(_string)
  if cd["confidence"] > 0.6
    _string.force_encoding(cd["encoding"])
  end
  #_string.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
  _string.encode!(Encoding::UTF_8)
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
