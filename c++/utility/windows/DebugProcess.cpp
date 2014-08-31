#include "stdafx.h"
#include <windows.h>
#include <stdio.h>

void testDebugProcess()
{
    STARTUPINFO si;    
    PROCESS_INFORMATION pi;    
    si.cb = sizeof(STARTUPINFO);
    GetStartupInfo(&si);
    si.wShowWindow = SW_HIDE;    
    si.dwFlags = STARTF_USESHOWWINDOW |STARTF_USESTDHANDLES;    
    TCHAR Dir[] = _T("e:/test/DumpProcess/Release/DumpProcess.exe");
    if(!CreateProcess(NULL,Dir,NULL,NULL,TRUE,DEBUG_ONLY_THIS_PROCESS,NULL,NULL,&si,&pi)) 
    {    
        printf("Error on CreateProcess()");    
        return;    
    }

    DEBUG_EVENT de; 
    while (WaitForDebugEvent(&de,INFINITE)!=0) 
    { 
        if (de.dwDebugEventCode == CREATE_PROCESS_DEBUG_EVENT) 
            printf("create\n"); 
        if (de.dwDebugEventCode == EXCEPTION_DEBUG_EVENT) 
        { 
            switch   (de.u.Exception.ExceptionRecord.ExceptionCode) 
            { 
            case   EXCEPTION_INT_DIVIDE_BY_ZERO: 
                printf("zero\n"); 
                TerminateProcess(pi.hProcess,1); 
                break; 
            case   EXCEPTION_INT_OVERFLOW: 
                printf("INT\n"); 
                TerminateProcess(pi.hProcess,1); 
                break; 
            case   EXCEPTION_ACCESS_VIOLATION: 
                printf("ACCESS\n"); 
                TerminateProcess(pi.hProcess,1); 
                break; 
            case   EXCEPTION_DATATYPE_MISALIGNMENT: 
                printf("DATATYPE\n"); 
                TerminateProcess(pi.hProcess,1); 
                break; 
            case   EXCEPTION_FLT_STACK_CHECK: 
                printf("DATATYPE\n"); 
                TerminateProcess(pi.hProcess,1); 
                break; 
            case   EXCEPTION_INVALID_DISPOSITION: 
                printf("DISPOSITION\n"); 
                TerminateProcess(pi.hProcess,1); 
                break; 
            case   EXCEPTION_STACK_OVERFLOW: 
                printf("OVERFLOW\n"); 
                TerminateProcess(pi.hProcess,1); 
                break; 
            default: 
                printf("exceptioncode:%x\n", de.u.Exception.ExceptionRecord.ExceptionCode); 
            }    
        } 
        if   (de.dwDebugEventCode == EXIT_PROCESS_DEBUG_EVENT) 
        { 
            printf("exit\n"); 
            break; 
        } 
        ContinueDebugEvent(pi.dwProcessId,pi.dwThreadId,DBG_CONTINUE); 
    }
}