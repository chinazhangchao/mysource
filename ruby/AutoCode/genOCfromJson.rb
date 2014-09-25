require 'json'
require 'set'

module ParseConfig
  TypeMap = {"".class => "@property (nonatomic,copy)   NSString*", 1.class => "@property (nonatomic,assign) NSInteger", 1.0.class => "@property (nonatomic,copy)   NSFloat",
    true.class => "@property (nonatomic,assign)   BOOL", false.class => "@property (nonatomic,assign)   BOOL"}

  ToFuncMap = {1.class => "integerValue", 1.0.class => "toDouble",
    true.class => "toBool", false.class => "toBool"}

  NeedDealloc = ["".class]
end

def ProcessKV(k, v, varDeclare, deallocList, fromDic)
  vclass = v.class
  formatstr = "%s %s;\n"
  if ParseConfig::TypeMap.include?(vclass)
    varDeclare << (formatstr % ["#{ParseConfig::TypeMap[vclass]}", "#{k}"])
    deallocList << "\tSAFE_RELEASE(_#{k});\n" if ParseConfig::NeedDealloc.find_index(vclass)

    if ParseConfig::ToFuncMap.include?(vclass)
      fromDic << "\tif ([dic objectForKey:@\"#{k}\"]) {\n\t\tnode.#{k} = [[dic objectForKey:@\"#{k}\"] #{ParseConfig::ToFuncMap[vclass]}];\n\t}\n"
    else
      str = <<TEST
    if ([dic objectForKey:@\"#{k}\"]) {
        node.#{k} = [dic objectForKey:@\"#{k}\"];
    }
TEST
      fromDic << str
    end
  elsif vclass == nil.class
    puts "warning:null object #{k}, #{v}"
  # elsif vclass == {"k"=>"v"}.class
  #   GenerateStruct("#{k}", v)
  #   construct << "\t\t#{k.downcase} = #{k}(val[\"#{k.downcase}\"].toObject());\n"
  #   includeList << "#include \"#{k}.h\"\n"
  #   varDeclare << (formatstr % ["#{k}", "#{k.downcase}"])
  #   toJson << "\t\tobj.insert(\"#{k}\", #{k}.ToJson());\n"
  else
    puts "unkonwn:#{vclass} #{k}, #{v}"
  end
end

def GenerateStruct(structName, structHash)
  headFileName = structName + ".h"
  #return if File.exist?(headFileName)

  sourceFileName = structName + ".m"

  headFile = File.new(headFileName, "wt")
  sourceFile = File.new(sourceFileName, "wt")

  import = "#import <Foundation/Foundation.h>\n\n@interface #{structName} : NSObject\n"
  varDeclare = ""
  fromJson = "+(#{structName} *) fromDic:(NSDictionary *)dic;\n+(BOOL) addToArrayFromDic: (NSMutableArray*)resultArray r:(NSDictionary *)dic;\n"
  deallocList = "- (void)dealloc\n{\n"
  fromDic = "+(#{structName} *) fromDic:(NSDictionary *)dic\n{\n\t#{structName} *node = [[#{structName} alloc]init];\n"
  addToArrayFromDic = <<HERE
+(BOOL) addToArrayFromDic: (NSMutableArray*)resultArray r:(NSDictionary *)dic
{
    if (!dic) return NO;
    #{structName} *p = [#{structName} fromDic:dic];
    [resultArray addObject:p];
    [p release];
    return YES;
}
HERE
  structHash.each{|k,v| ProcessKV(k, v, varDeclare, deallocList, fromDic)}
  deallocList<< "\n\t[super dealloc];\n}\n\n"
  fromDic << "\treturn node;\n}\n\n"

  headFile << import << "\n" << varDeclare << "\n" << fromJson << "\n@end"

  sourceFile << "\#import \"#{headFileName}\"\n\n@implementation #{structName}\n\n"
  sourceFile << deallocList << fromDic << addToArrayFromDic<<"\n@end"

  headFile.close
  sourceFile.close
end

def parseJsonFile(fileName)
	f = File.new('SS.json', "rt")

  jsonStr = f.read
  my_hash = JSON.parse(jsonStr)

  orgClassName = my_hash.keys[0]
  className = orgClassName.chomp("_list")
  className = className.chomp("List")
  className << "Node"

  messageHash = my_hash[orgClassName]

  GenerateStruct(className, messageHash)
end

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
parseJsonFile('SS.json')