require "rexml/document"

Dir.chdir("e:/test/AutoCode/")

doc = REXML::Document.new(File.new("testMessage.xml"))

className = doc.root.name

allElems = doc.root.elements

nodeArray = []

allElems.each{|e| nodeArray.push(e.name) }

headFileName = className + ".h"

sourceFileName = className + ".cpp"

headMacroDefine = headFileName.upcase

headMacroDefine = headMacroDefine.gsub(".", "_")

headMacroDefine = "__" + headMacroDefine + "__"

headContentTemplate = <<CLASSHEADCONTENT
#ifndef HEADMACRODEFINE
#define HEADMACRODEFINE

#include "IPassiveCmd.h"

class CLASSNAME : public IPassiveCmd
{
    Q_OBJECT

public:
    CLASSNAME();
    ~CLASSNAME();

    virtual bool ParserRequest(QString sRequest);

    virtual bool MakeResponseCmd();

    virtual bool requestFinish(QString sXML);
private:
    
};

#endif // HEADMACRODEFINE
CLASSHEADCONTENT

sourceContentTemplate = <<CLASSSOURCECONTENT
#include "HEADFILENAME"
#include "HelpFunction.h"
#include "ConstStringHelper.h"

CLASSNAME::CLASSNAME()
{

}

CLASSNAME::~CLASSNAME()
{

}

bool CLASSNAME::ParserRequest(QString sRequest)
{
    bool bRet = true;
    QString sTemp;
    QXmlStreamReader xml( sRequest );

    while ( !xml.atEnd() )
    {
        xml.readNext();
        if ( xml.isStartElement() )
        {
            QString name = xml.name().toString().trimmed();
        }
    }

    if ( !xml.hasError() )
    {
        
    }
    else
    {
        bRet = false;
    }

    return bRet;
}

bool CLASSNAME::MakeResponseCmd()
{
    return false;
}

bool CLASSNAME::requestFinish(QString sXML)
{
    return false;
}
CLASSSOURCECONTENT

headFile = File.new(headFileName, "w+t")

headcontent = headContentTemplate.gsub("HEADMACRODEFINE", headMacroDefine)

headcontent = headcontent.gsub("CLASSNAME", className)

headFile.write(headcontent)

headFile.close

sourceFile = File.new(sourceFileName, "w+t")

sourceContent = sourceContentTemplate.gsub("HEADFILENAME", headFileName)

sourceContent = sourceContent.gsub("CLASSNAME", className)

sourceFile.write(sourceContent)

sourceFile.close
