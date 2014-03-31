#include "UUVersion.h"
#include "HelpFunction.h"
#include "ConstStringHelper.h"

UUVersion::UUVersion()
{

}

UUVersion::~UUVersion()
{

}

bool UUVersion::ParserRequest(QString sRequest)
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

bool UUVersion::MakeResponseCmd()
{
    return false;
}

bool UUVersion::requestFinish(QString sXML)
{
    return false;
}
