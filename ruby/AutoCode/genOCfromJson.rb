require 'json'
require 'set'

module ParseConfig
  TypeMap = {"".class => "QString", 1.class => "NSInteger", 1.0.class => "double",
    true.class => "bool", false.class => "bool"}

  ToFuncMap = {"".class => "toString", 1.class => "toDouble", 1.0.class => "toDouble",
    true.class => "toBool", false.class => "toBool"}

  SourceBody = Struct.new(:construct, :toJson, :varDeclare, :includeList, :initList)
end

def ProcessKV(k, v, sourceContent)
  construct = sourceContent[:construct]
  toJson = sourceContent[:toJson]
  varDeclare = sourceContent[:varDeclare]
  includeList = sourceContent[:includeList]
  initList = sourceContent[:initList]
  vclass = v.class
  formatstr = "\t%-16s %s;\n"
  if $typeMap.include?(vclass)
    construct << "\t\t#{k} = val[\"#{k}\"].#{$toFuncMap[vclass]}();\n"
    toJson << "\t\tobj.insert(\"#{k}\", #{k});\n"
    varDeclare << (formatstr % ["#{$typeMap[vclass]}", "#{k}"])
    includeList << "#include <QString>\n" if vclass == "".class
    if vclass == 1.class || vclass == 1.0.class
      initList << "\t\t#{k} = 0;\n"
    elsif vclass == true.class || vclass == false.class
      initList << "\t\t#{k} = false;\n"
    end
  elsif vclass == [].class
    eleclass = v[0].class
    arrTemplate = "\t\tQJsonArray #{k}Arr;\n\t\tfor (auto i : #{k})\n\t\t{\n\t\t\t#{k}Arr.push_back(ELE);\n\t\t}\n\t\tobj.insert(\"#{k}\", #{k}Arr);\n"
    includeList << "#include <QList>\n"
    if $typeMap.include?(eleclass)
      varName = "#{k}List"
      varDeclare << (formatstr % ["QList<#{$typeMap[eleclass]}>", "#{varName}"])
      arrTemplate = arrTemplate.gsub(/\bELE\b/, "i")
      construct << "\t\tfor (auto i : val[\"#{k}\"].toArray())\n\t\t{\n\t\t\t#{varName}.push_back(i.#{$toFuncMap[eleclass]}());\n\t\t}\n"
    elsif eleclass == {"k"=>"v"}.class
      GenerateStruct("#{k}", v[0])
      varName = "#{k.downcase}List"
      includeList << "#include \"#{k}.h\"\n"
      varDeclare << (formatstr % ["QList<#{k}>", "#{varName}"])
      arrTemplate = arrTemplate.gsub(/\bELE\b/, "i.ToJson()")
      construct << "\t\tfor (auto i : val[\"#{k}\"].toArray())\n\t\t{\n\t\t\t#{varName}.push_back(#{k}(i));\n\t\t}\n"
    else
      puts "unkonwn:#{eleclass} #{vclass[0]}"
    end
    toJson << arrTemplate
  elsif vclass == nil.class
    puts "warning:null object #{k}, #{v}"
  elsif vclass == {"k"=>"v"}.class
    GenerateStruct("#{k}", v)
    construct << "\t\t#{k.downcase} = #{k}(val[\"#{k.downcase}\"].toObject());\n"
    includeList << "#include \"#{k}.h\"\n"
    varDeclare << (formatstr % ["#{k}", "#{k.downcase}"])
    toJson << "\t\tobj.insert(\"#{k}\", #{k}.ToJson());\n"
  else
    puts "unkonwn:#{vclass} #{k}, #{v}"
  end
end

def GenerateStruct(structName, structHash)
  headFileName = structName + ".h"
  #return if File.exist?(headFileName)

  sourceFileName = structName + ".cpp"

  headFile = File.new(headFileName, "wt")
  varDeclare = ""
  construct = "\t#{structName}(const QJsonObject &val)\n\t{\n"
  toJson = "\tQJsonObject ToJson()\n\t{\n\t\tQJsonObject obj;\n"
  includeList = Set.new
  initList = ""
  sourceContent = SourceBody.new(construct, toJson, varDeclare, includeList, initList)
  structHash.each{|k,v| ProcessKV(k, v, sourceContent)}
  headFile << "\n"
  construct << "\t}\n\n"
  toJson << "\t\treturn obj;\n\t}\n\n"
  headFile << structHead
  headFile << toJson
  headFile << varDeclare
  headFile.close
end

def parseJsonFile(fileName)
	f = File.new('SS.json', "rt", encoding: Encoding::UTF_8)

  jsonStr = f.read
  my_hash = JSON.parse(jsonStr)

  orgClassName = my_hash.keys[0]
  className = orgClassName.chomp("_list")
  className = className.chomp("List")

  messageHash = my_hash[orgClassName]

  GenerateStruct(className, messageHash)
end

parseJsonFile('SS.json')