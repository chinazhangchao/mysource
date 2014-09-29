require 'json'
require 'set'
require 'rchardet'

module ParseConfig
  TypeMap = {"".class => "@property (nonatomic,copy)   NSString*", 1.class => "@property (nonatomic,assign) NSInteger", 1.0.class => "@property (nonatomic,assign)   float",
    true.class => "@property (nonatomic,assign)   BOOL", false.class => "@property (nonatomic,assign)   BOOL"}

  ToFuncMap = {1.class => "integerValue", 1.0.class => "floatValue",
    true.class => "boolValue", false.class => "boolValue"}

  NeedDealloc = ["".class, [].class]
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

def ProcessKV(k, v, includeList, varDeclare, deallocList, fromDic)
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
  elsif vclass == [].class
    eleclass = v[0].class
    cn = "#{k}"
    cn.chomp!("_list")
    varDeclare << "@property (nonatomic,retain) NSMutableArray *#{cn}Array;\n"
    deallocList << "\tSAFE_RELEASE(_#{cn}Array);\n"
    nestType = ""
    str=""
    if ParseConfig::TypeMap.include?(eleclass)
      nestType="#{ParseConfig::TypeMap[eleclass]}"
      str=<<HERE
    NSArray* array = [dic objectForKey:@"#{k}"];
    if (array) {
        if (node.brandArray == nil) {
              node.brandArray = [NSMutableArray new];
          }
        for (NSInteger i =0; i<array.count; i++) {
          #{nestType} result = [array objectAtIndex:i];
          [node.#{cn}Array addObject:result];
        }
    }
HERE
    elsif eleclass == {"k"=>"v"}.class
      nestType="Pbcrc"+cn[0].upcase+cn[1..-1]+"Node"
      GenerateStruct(nestType, v[0])
      includeList << "#import \"#{nestType}.h\"\n"
      str=<<HERE
    NSArray* array = [dic objectForKey:@"#{k}"];
    if (array) {
      for (NSInteger i =0; i<array.count; i++) {
        NSDictionary* result = [array objectAtIndex:i];
        #{nestType} *n = [#{nestType} fromDic :result];
        [[node #{cn}Array] addObject:n];
        [n release];
      }
    }
HERE
    end
    fromDic << str
  elsif vclass == nil.class
    puts "warning:null object #{k}, #{v}"
  elsif vclass == {"k"=>"v"}.class
    GenerateStruct("#{k}", v)
    includeList << "#import \"#{k}.h\"\n"
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

  import = "#import <Foundation/Foundation.h>\n"
  classDeclare = "\n@interface #{structName} : NSObject\n"
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
  structHash.each{|k,v| ProcessKV(k, v, import, varDeclare, deallocList, fromDic)}
  deallocList<< "\n\t[super dealloc];\n}\n\n"
  fromDic << "\treturn node;\n}\n\n"

  headFile << import << classDeclare << varDeclare << "\n" << fromJson << "\n@end"

  sourceFile << "\#import \"#{headFileName}\"\n\n@implementation #{structName}\n\n"
  sourceFile << deallocList << fromDic << addToArrayFromDic<<"\n@end"

  headFile.close
  sourceFile.close
end

def parseJsonFile(fileName)
	f = File.new(fileName, "rt")

  jsonStr = f.read
  toUtf8(jsonStr)
  my_hash = JSON.parse(jsonStr)

  orgClassName = my_hash.keys[0]
  className = orgClassName.chomp("_list")
  className.chomp!("List")
  className = "Pbcrc" + className.capitalize + "Node"

  messageHash = my_hash[orgClassName]

  GenerateStruct(className, messageHash)
end

parseJsonFile('interface/detail_store_list.txt')