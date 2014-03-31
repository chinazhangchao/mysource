#include <windows.h>

bool EnableDebugPrivilege( bool bEnable )
{
    bool fOK = false;
    HANDLE hToken;
    if ( OpenProcessToken( GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES, &hToken ) )
    {
        //试图修改“调试”特权
        TOKEN_PRIVILEGES tp;
        tp.PrivilegeCount = 1;
        LookupPrivilegeValue( NULL, SE_DEBUG_NAME, &tp.Privileges[0].Luid );
        tp.Privileges[0].Attributes = bEnable ? SE_PRIVILEGE_ENABLED : 0;
        AdjustTokenPrivileges( hToken, FALSE, &tp, sizeof( tp ), NULL, NULL );
        fOK = ( GetLastError() == ERROR_SUCCESS );
        CloseHandle( hToken );
    }

    return fOK;
}