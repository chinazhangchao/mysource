
HeadContentTemplate = File.read("cv.h")

SourceContentTemplate = File.read("cv.m")

def gen(className)
  headFileName = className + ".h"

  sourceFileName = className + ".m"

  headFile = File.new(headFileName, "w+t")

  headcontent = HeadContentTemplate.gsub("CLASSNAME", className)

  headFile.write(headcontent)

  headFile.close

  sourceFile = File.new(sourceFileName, "w+t")

  sourceContent = SourceContentTemplate.gsub("CLASSNAME", className)

  sourceFile.write(sourceContent)

  sourceFile.close
end

File.foreach("cl.txt") { |line| gen("#{line.strip}ViewController") unless line.strip.empty? }
