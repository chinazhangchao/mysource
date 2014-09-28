require 'json'
require 'rchardet'
require 'set'

module ParseConfig
  TypeMap = {"".class => "String", 1.class => "long", 1.0.class => "double",
    true.class => "bool", false.class => "bool"}
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

def ProcessKV(k, v, includeList, varDeclare, getVar)
  vclass = v.class
  if ParseConfig::TypeMap.include?(vclass)
    fieldName = "#{k}"
    underIndex = fieldName.index("_")
    if underIndex
      varDeclare << "\t@SerializedName(\"#{fieldName}\")\n"
      fieldName = fieldName[underIndex+1..-1]
    end
    varDeclare << "\tprivate #{ParseConfig::TypeMap[vclass]} #{fieldName};\n"
    getMethod = "get#{fieldName[0].upcase+fieldName[1..-1]}"
    getStr = ""
    if vclass == "".class
      getStr=<<HERE
      public String #{getMethod}() {
        if (#{fieldName} == null) {
            return "";
        }
        return #{fieldName};
    }
HERE
    else
      getStr =<<HERE
      public long #{getMethod}() {
        return #{fieldName};
    }
HERE
      getVar << getStr << "\n"
    end
  elsif vclass == [].class
    eleclass = v[0].class
    cn = "#{k}"
    nestType = ""
    str=""
    if ParseConfig::TypeMap.include?(eleclass)
      nestType="#{ParseConfig::TypeMap[eleclass]}"
      str=<<HERE
    public List<#{nestType}> getPbcrcList() {
        if (storeList == null) {
            return new ArrayList<#{nestType}>();
        }
        return storeList;
    }
HERE
    elsif eleclass == {"k"=>"v"}.class
      nestType = cn.chomp("_list")
      nestType.chomp!("List")
      nestType = "Pbcrc" + nestType.capitalize
      GenerateStruct(nestType, v[0])
      includeList << "import com.imohoo.favorablecard.model.apitype.#{nestType};\n"
      str=<<HERE
    public List<#{nestType}> getPbcrcList() {
        if (storeList == null) {
            return new ArrayList<#{nestType}>();
        }
        return storeList;
    }
HERE
    end
    varDeclare << "private List<#{nestType}> #{k}"
  elsif vclass == nil.class
    puts "warning:null object #{k}, #{v}"
  elsif vclass == {"k"=>"v"}.class
    GenerateStruct("#{k}", v)
    includeList << "import com.imohoo.favorablecard.model.apitype.#{k};\n"
  else
    puts "unkonwn:#{vclass} #{k}, #{v}"
  end
end

def GenerateStruct(structName, structHash)
  headFileName = structName + ".java"
  #return if File.exist?(headFileName)

  headFile = File.new(headFileName, "wt")
  package = "package com.imohoo.favorablecard.model.result.rebate;\n"

  import = "import com.google.gson.annotations.SerializedName;\n"
  classDeclare = "\npublic class #{structName} {\n"
  varDeclare = ""
  getVar=""
  structHash.each{|k,v| ProcessKV(k, v, import, varDeclare, getVar)}

  headFile << package << import << classDeclare << varDeclare << "\n" << getVar << "}"

  headFile.close
end

def parseJsonFile(fileName)
	f = File.new(fileName, "rt")

  # f=File.new("interface/detail_store_list.txt", "rt")
  jsonStr = f.read
  toUtf8(jsonStr)
  my_hash = JSON.parse(jsonStr)

  orgClassName = my_hash.keys[0]
  className = orgClassName.chomp("_list")
  className.chomp!("List")
  className = className.capitalize+"Result"

  messageHash = my_hash[orgClassName]

  GenerateStruct(className, messageHash)
end

parseJsonFile('interface/detail_store_list.txt')
