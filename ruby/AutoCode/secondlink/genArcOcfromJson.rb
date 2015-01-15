require 'json'
require 'set'
require 'rchardet'
require '../../Util/helper.rb'
require 'rails'

module ParseConfig
  TypeMap = {"".class => "@property (nonatomic, strong)\tNSString*", 1.class => "@property (nonatomic, assign)\tlong", 1.0.class => "@property (nonatomic, assign)\tfloat",
    true.class => "@property (nonatomic, assign)\tBOOL", false.class => "@property (nonatomic, assign)\tBOOL"}

  ToFuncMap = {1.class => "longValue", 1.0.class => "floatValue",
    true.class => "boolValue", false.class => "boolValue"}

  NeedDealloc = ["".class, [].class]
end

def ProcessKV(k, v, includeList, varDeclare, fromDic)
  vclass = v.class
  formatstr = "%s %s;\n"
  if ParseConfig::TypeMap.include?(vclass)
    varDeclare << (formatstr % ["#{ParseConfig::TypeMap[vclass]}", "#{k}"])

    if ParseConfig::ToFuncMap.include?(vclass)
      fromDic << "\n\tnode.#{k} = [[dic objectForKey: @\"#{k}\"] #{ParseConfig::ToFuncMap[vclass]}];"
    else
      fromDic << "\n\tnode.#{k} = [dic objectForKey: @\"#{k}\"];"
    end
  elsif vclass == [].class
    eleclass = v[0].class
    cn = "#{k}"
    cn.chomp!("_list")
    varDeclare << "@property (nonatomic, strong) NSMutableArray *#{cn}Array;\n"
    nestType = ""
    str=""
    if ParseConfig::TypeMap.include?(eleclass)
      nestType="#{ParseConfig::TypeMap[eleclass]}"
      str=<<HERE
    NSArray* array = [dic objectForKey: @"#{k}"];
    if (array) {
        if (node.brandArray == nil) {
              node.brandArray = [NSMutableArray new];
          }
        for (NSInteger i = 0; i < array.count; i++) {
          #{nestType} result = [array objectAtIndex: i];
          [node.#{cn}Array addObject: result];
        }
    }
HERE
    elsif eleclass == {"k"=>"v"}.class
      nestType = cn.camelize + "Node"
      GenerateStruct(nestType, v[0])
      includeList << "#import \"#{nestType}.h\"\n"
      str=<<HERE
    NSArray* array = [dic objectForKey: @"#{k}"];
    if (array) {
      for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary* result = [array objectAtIndex: i];
        #{nestType} *n = [#{nestType} fromDic: result];
        [[node #{cn}Array] addObject: n];
        [n release];
      }
    }
HERE
    end
    fromDic << str
  elsif vclass == nil.class
    puts "warning:null object #{k}, #{v}"
  elsif vclass == {"k"=>"v"}.class
    cn = "#{k}"
    varName = cn + "Node"
    nestType = cn.camelize + "Node"
    GenerateStruct(nestType, v)
    includeList << "#import \"#{nestType}.h\"\n"
    varDeclare << "@property (nonatomic, strong)\t#{nestType} *#{varName};\n"
    fromDic << "\n\tnode.#{k} = [dic objectForKey: @\"#{k}\"];"
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
  classDeclare = "\n@interface #{structName}: NSObject\n\n"
  varDeclare = ""
  fromJson = "+(#{structName} *) fromDic: (NSDictionary *)dic;\n"

  addToArrayFromDicDeclar = "+(BOOL) addToArrayFromDic: (NSMutableArray*)resultArray r:(NSDictionary *)dic;\n"

  fromDic = "+(#{structName} *) fromDic: (NSDictionary *)dic\n{\n\t#{structName} *node = [[#{structName} alloc] init];\n"

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
  structHash.each{|k,v| ProcessKV(k, v, import, varDeclare, fromDic)}

  fromDic << "\n\n\treturn node;\n}\n"

  headFile << import << classDeclare << varDeclare << "\n" << fromJson << "\n@end"

  sourceFile << "\#import \"#{headFileName}\"\n\n@implementation #{structName}\n\n"
  sourceFile << fromDic <<"\n@end"

  headFile.close
  sourceFile.close
end

def parseJsonFile(fileName)
	f = File.new(fileName, "rt")

  jsonStr = f.read
  Helper.toUtf8(jsonStr)
  messageHash = JSON.parse(jsonStr)

  # orgClassName = my_hash.keys[0]
  className = File.basename(fileName, ".json")
  className = className.camelize + "Node"

  # messageHash = my_hash[orgClassName]

  GenerateStruct(className, messageHash)
end

Dir.glob("./*.json"){|f| parseJsonFile(f)}
# Dir.glob("./*.json"){|f| puts f}
# parseJsonFile('pbcrc/wallet_bill_list.txt')