require 'libxml'
require 'set'

xmlStr='<test>body</test>'
doc = LibXML::XML::Document.string(xmlStr)
my_hash = JSON.parse(xmlStr)

className = my_hash.keys[0]

$typeMap = {"".class => "QString", 1.class => "double", 1.0.class => "double",
	true.class => "bool", false.class => "bool"}

$toFuncMap = {"".class => "toString", 1.class => "toDouble", 1.0.class => "toDouble",
	true.class => "toBool", false.class => "toBool"}

$sourceBody = Struct.new(:construct, :toJson, :varDeclare, :includeList, :initList)

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
    headMacroDefine = headFileName.upcase
    headMacroDefine = headMacroDefine.gsub(".", "_")
    headMacroDefine = "__" + headMacroDefine + "__"
	
	headFile = File.new(headFileName, "wt")
	beginmacro = "#ifndef HEADMACRODEFINE\n#define HEADMACRODEFINE\n\n"
	beginmacro = beginmacro.gsub(/\bHEADMACRODEFINE\b/, headMacroDefine)
	headFile << beginmacro
	structHead = "struct #{structName}\n{\n"
	varDeclare = ""
	defaultConstruct = "\t#{structName}(){}\n\n"
	construct = "\t#{structName}(const QJsonObject &val)\n\t{\n"
	toJson = "\tQJsonObject ToJson()\n\t{\n\t\tQJsonObject obj;\n"
	includeList = Set.new
	initList = ""
	sourceContent = $sourceBody.new(construct, toJson, varDeclare, includeList, initList)
	structHash.each{|k,v| ProcessKV(k, v, sourceContent)}
	includeList << "#include <QJsonObject>\n"
	includeList.each{|h| headFile << h}
	headFile << "\n"
	construct << "\t}\n\n"
	toJson << "\t\treturn obj;\n\t}\n\n"
	headFile << structHead
	unless initList.empty?
		#initList = "\tvoid Init()\n\t{\n" + initList + "\t}\n\n"
		#headFile << initList
		defaultConstruct = "\t#{structName}()\n\t{\n#{initList}\t}\n\n"
	end
	headFile << defaultConstruct
	headFile << construct
	headFile << toJson
	headFile << varDeclare
	endmacro = "};\n\n#endif //HEADMACRODEFINE"
	endmacro = endmacro.gsub(/\bHEADMACRODEFINE\b/, headMacroDefine)
	headFile << endmacro
	headFile.close
end

messageHash = my_hash[className]

GenerateStruct(className, messageHash)