
require 'fileutils'

srcdir="d:/newsuoyou/"
dstdir="d:/gameinfo/"
zipFileName="GameCenter.zip"
srcFiles=["games.txt","actiongames.txt","adventuregames.txt","arcadegames.txt",
"casinogames.txt","cardgames.txt","familygames.txt","hiddenobjectgames.txt",
"puzzlegames.txt","simulationgames.txt","sportgames.txt","strategygames.txt",
"triviagames.txt","suggested.txt","trending.txt","top_rated.txt"]

def ignoreNotExistCopy(srcFiles, srcDir, dstDir)
	FileUtils.cd(srcDir)
	srcFiles.each do |f|
		fullName = srcDir + f
		destName = dstDir + f
		FileUtils.copy_file(fullName, destName) if File.exist?(fullName)
	end
end

ignoreNotExistCopy(srcFiles, srcdir, dstdir)

require 'zip'
FileUtils.cd(dstdir)
FileUtils.rm_f(zipFileName)
srcFiles += ["category.txt", "index.txt"]
Zip::File.open(zipFileName, "w") {
|zf|
srcFiles.each{|file| zf.add(file, file)}
}