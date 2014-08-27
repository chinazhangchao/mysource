#ifndef __UUVERSION_H__
#define __UUVERSION_H__

#include "IPassiveCmd.h"

class UUVersion : public IPassiveCmd
{
    Q_OBJECT

public:
    UUVersion();
    ~UUVersion();

    virtual bool ParserRequest(QString sRequest);

    virtual bool MakeResponseCmd();

    virtual bool requestFinish(QString sXML);
private:
    
};

#endif // __UUVERSION_H__
