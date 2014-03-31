#pragma once
#include <QString>
#include "qstring.h"

class ConstStringHelper
{
public:
	//protocol begin
	static const QString UUCORE;
	static const QString BizDownLoad;
	static const QString BizKeepAlive;
	static const QString BizModuleInfo;
	
	static const QString BizResponse;
	static const QString url;
	static const QString cookie;
	static const QString locPath;
	static const QString content;
	static const QString isSuccess;
	static const QString errorCode;
	static const QString bytesReceived;
	static const QString bytesTotal;
	static const QString speed;
	static const QString process;
	static const QString isFinish;
	static const QString req;
	static const QString state;
	static const QString troy;
	static const QString proxy;
	static const QString type;
	static const QString stateCode;
	static const QString reason;
	//protocol end

	static const QString ProtocolFormat;

	static const QString speedBS;
	static const QString speedKBS;
	static const QString speedMBS;

	static const QString Socks5;
	static const QString Http;

	static const int SpiltCount = 10;
	
	static const QString FileNameError;
	static const QString FileDownLoad;

	static const QString NodeVersion;
	static const QString NodeName;

	static const QString Version;
	static const QString ModuleName;

	static const QString BizSettingDir;
	static const QString dir;

    static const QString UUAUTHORIZATION;
    static const QString ACCOUNT;
    static const QString CLIENTTYPE;
    static const QString CLIENTVERSION;
    static const QString USERTYPE;
};

