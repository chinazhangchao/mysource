require 'rchardet'

module Helper

  class << self

    def stringToUri(l)
      begin
        u=URI.parse(l)
      rescue URI::InvalidURIError => e
        l=URI.escape(l)
        u=URI.parse(l)
      end
    end

    def toUtf8(_string)
      strEncoding = _string.encoding 
      if strEncoding == Encoding::ASCII_8BIT || strEncoding == Encoding::US_ASCII
        cd = CharDet.detect(_string)
        if cd["confidence"] > 0.6
          _string.force_encoding(cd["encoding"])
        end
        #_string.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
        _string.encode!(Encoding::UTF_8)
      elsif strEncoding != Encoding::UTF_8
        _string.encode!(Encoding::UTF_8)
      end

      return _string
    end

    def formMethod(methodNameSymbol, objectName = nil)
      if methodNameSymbol == nil
        return nil
      elsif objectName == nil
        method(methodNameSymbol)
      else
        return objectName.method(methodNameSymbol)
      end
    end

  end

end
