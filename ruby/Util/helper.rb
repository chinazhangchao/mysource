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

    CodingBomMap = {"UTF-8" => "\xEF\xBB\xBF".force_encoding("UTF-8"),
      "UTF-16BE"=>"\xFE\xFF".force_encoding("UTF-16BE"),
      "UTF-16LE"=>"\xFF\xFE".force_encoding("UTF-16LE"),
      "UTF-32BE"=>"\x00\x00\xFE\xFF".force_encoding("UTF-32BE"),
      "UTF-32LE"=>"\xFF\xFE\x00\x00".force_encoding("UTF-32LE")}

    def toUtf8(_string)
      strEncoding = _string.encoding 
      if strEncoding == Encoding::ASCII_8BIT || strEncoding == Encoding::US_ASCII
        cd = CharDet.detect(_string)
        if cd["confidence"] > 0.6
          _string.force_encoding(cd["encoding"])
          #移除BOM头
          bomHeader = CodingBomMap[cd["encoding"]]
          _string.gsub!(bomHeader, "") if bomHeader
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
