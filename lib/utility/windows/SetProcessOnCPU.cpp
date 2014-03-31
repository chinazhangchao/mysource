#include "stdafx.h"
#include <windows.h>

void SetProcessOnCPU()
{
    //get system info
    SYSTEM_INFO SystemInfo;
    GetSystemInfo( &SystemInfo );

    printf( "dwNumberOfProcessors=%u, dwActiveProcessorMask=%x,\n wProcessorLevel=%u, "
        "wProcessorArchitecture=%u, dwPageSize=%u\n ",
        SystemInfo.dwNumberOfProcessors, SystemInfo.dwActiveProcessorMask, SystemInfo.wProcessorLevel,
        SystemInfo.wProcessorArchitecture, SystemInfo.dwPageSize
        );
    DWORD nProcessorNum = SystemInfo.dwNumberOfProcessors;
    if ( nProcessorNum <= 1 )
    {
        return;
    }

    DWORD_PTR dwMask = 0;

    for ( DWORD i = nProcessorNum; i > 0; i-- )
    {
        if ( SystemInfo.dwActiveProcessorMask & i )
        {
            dwMask = 1 << ( i - 1 );
            break;
        }
    }//end of for

    //进程与指定cpu绑定
    BOOL ret = SetProcessAffinityMask( GetCurrentProcess(), dwMask );
    if ( !ret )
    {
        DWORD err = GetLastError();
        printf( "SetProcessOnCPU error:%d\n", err );
    }
    //线程与指定cpu绑定
    //SetThreadAffinityMask(GetCurrentThread(),dwMask);
}