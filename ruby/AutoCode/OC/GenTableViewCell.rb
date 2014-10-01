require '../../Util/helper'

HeadContentTemplate = Helper.toUtf8(File.read("tvc.h"))

SourceContentTemplate = Helper.toUtf8(File.read("tvc.m"))

def gen(className)
  headFileName = className + "Cell.h"

  sourceFileName = className + "Cell.m"

  headFile = File.new(headFileName, "w+t")

  headcontent = HeadContentTemplate.gsub("CLASSNAME", className)

  headFile.write(headcontent)

  headFile.close

  sourceFile = File.new(sourceFileName, "w+t")

  sourceContent = SourceContentTemplate.gsub("CLASSNAME", className)

  sourceFile.write(sourceContent)

  sourceFile.close
end

File.foreach("tl.txt") { |line| gen("#{line.strip}") unless line.strip.empty? }
