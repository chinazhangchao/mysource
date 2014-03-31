// 写指定扇区工具Dlg.cpp : implementation file
//

#include "stdafx.h"
#include "写指定扇区工具.h"
#include "写指定扇区工具Dlg.h"
#include <sstream>
#include <fstream>

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#ifndef WM_Tray
#define WM_Tray WM_USER+100
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	CHyperlink	m_hyperlink;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
	m_hyperlink.SetHyperlink("hi.baidu.com/liuqizealot");

}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	DDX_Control(pDX, IDC_LIUQI, m_hyperlink);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMyDlg dialog

CMyDlg::CMyDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CMyDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CMyDlg)
	m_shanqu = 1;
	m_write = _T("");
	m_read = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CMyDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CMyDlg)
	DDX_Text(pDX, IDC_EDIT1, m_shanqu);
	DDV_MinMaxInt(pDX, m_shanqu, 1, 1440);
	DDX_Text(pDX, IDC_EDIT4, m_write);
	DDX_Text(pDX, IDC_EDIT3, m_read);
	//}}AFX_DATA_MAP
	DDX_Control(pDX, IDC_STATICFILEINFO, m_fileInfo);
}

BEGIN_MESSAGE_MAP(CMyDlg, CDialog)
	//{{AFX_MSG_MAP(CMyDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_EN_CHANGE(IDC_EDIT1, OnChangeEdit1)
	ON_BN_CLICKED(IDC_BTNSRCFILE, OnButtonSrcFile)
	ON_BN_CLICKED(IDC_BTNDSTIMG, OnButtonDstImg)
	ON_BN_CLICKED(IDC_BTNWRITE, OnButtonWrite)
	ON_BN_CLICKED(IDC_RADIO1, OnRadio1)
	ON_BN_CLICKED(IDC_RADIO2, OnRadio2)
	ON_BN_CLICKED(IDC_RADIO3, OnRadio3)
	ON_BN_CLICKED(IDC_BTNFLOPPY, OnButtonFloppy)
	//}}AFX_MSG_MAP
	ON_COMMAND(ID_EXIT, OnExit)
	ON_COMMAND(ID_ABOUTBOX, OnAbout)
	ON_MESSAGE(WM_Tray,OnTray)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMyDlg message handlers

BOOL CMyDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	m_stTray.cbSize=sizeof(NOTIFYICONDATA);
	m_stTray.hWnd=m_hWnd;
	strcpy_s(m_stTray.szTip, sizeof(m_stTray.szTip), "自动关机"); 
	m_stTray.uCallbackMessage=WM_Tray;   
	m_stTray.uID=IDR_MAINFRAME;
	m_stTray.hIcon=m_hIcon;
	
	m_stTray.uFlags=NIF_MESSAGE | NIF_TIP | NIF_ICON;	

	Shell_NotifyIcon(NIM_ADD,&m_stTray);

	((CButton*)GetDlgItem(IDC_RADIO1))->SetCheck(1);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CMyDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	switch(nID)
	{
		case SC_MINIMIZE: ShowWindow(SW_HIDE);
			break;

		case SC_CLOSE:
			if(IDOK == MessageBox("您确定要退出吗？  ","ImBox", MB_OKCANCEL | MB_ICONQUESTION )){ 
				Shell_NotifyIcon(NIM_DELETE,&m_stTray); 
				exit(0);
			}
			break;

		default:CDialog::OnSysCommand(nID, lParam);
			break;
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CMyDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CMyDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CMyDlg::OnOK() 
{
	
}

void CMyDlg::OnCancel() 
{
	//CDialog::OnCancel();
	
}


void CMyDlg::OnChangeEdit1() 
{
	UpdateData(true);
	
}

BOOL SelectFile(char BASED_CODE szFilter[], char (&strSelectFile)[1024], BOOL flag)
{
	CFileDialog * fdlg
		= new CFileDialog(flag, NULL, NULL, OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT /*| OFN_FORCESHOWHIDDEN*/, szFilter, NULL);

	if(fdlg->DoModal() == IDCANCEL){
		delete fdlg;
		return FALSE;
	}

	CString file = fdlg->GetPathName();

	delete fdlg;

	if(file.GetLength() > 1023)
		return FALSE;

	size_t bufSize = sizeof(strSelectFile);

	strcpy_s(strSelectFile, bufSize, (LPCTSTR)file);

	return TRUE;
}

void CMyDlg::OnButtonSrcFile() 
{
	char strSelectFile[1024];
	static char BASED_CODE szFilter[] = "EXE Files (*.exe)|*.exe|Image Files (*.bin)|*.bin|All Files(*.*)|*.*|";

	if(!SelectFile(szFilter, strSelectFile, true)){
		return;
	}

	m_read = strSelectFile;
	std::ifstream dosFile(strSelectFile);
	std::ostringstream fileBuf;
	fileBuf << dosFile.rdbuf();
	ReadDosHeader(reinterpret_cast<const BYTE*>(fileBuf.str().c_str()));
	UpdateData(false);
}

void CMyDlg::OnButtonDstImg() 
{
	char strSelectFile[1024];
	static char BASED_CODE szFilter[] = "Image Files (*.img)|*.img|All Files(*.*)|*.*|";

	if(!SelectFile(szFilter, strSelectFile, true)){
		return;
	}
	m_write = strSelectFile;
	UpdateData(false);
}

void CMyDlg::OnButtonWrite() 
{
	unsigned char str[513];
	unsigned int temp;

	UpdateData(true);

	if(m_shanqu < 1 || m_shanqu > 1440)
		return;

	if(m_read.IsEmpty()){
		AfxMessageBox("请指定需要写入的文件!  ", MB_ICONWARNING);
        return;
	}

	if(m_write.IsEmpty()){
		AfxMessageBox("请指定写入的映像文件!  ", MB_ICONWARNING);
        return;
	}


	CFile fileR,fileW;
	if(!fileR.Open(m_read, CFile::modeReadWrite | CFile::typeBinary )){
		AfxMessageBox("文件不存在或者被其他程序被占用!  ", MB_ICONWARNING);
        return;
	}

	//::CopyFile(m_write, m_write+".bak", false);

	if(!fileW.Open(m_write, CFile::modeReadWrite | CFile::typeBinary)){
		AfxMessageBox("文件不存在或者被其他程序被占用!  ", MB_ICONWARNING);
        return;
	}

	fileR.Read(str, 2);
	if(!memcmp(str, "MZ", 2)){
		//校验和通常是0无法作为进一步检测的条件，所以用最后1扇区的字节数来判断
		fileR.Read((char *)str, 1);
		temp = str[0];
		fileR.Read((char *)str, 1);
		temp += str[0]*256;
		if((unsigned long )temp == fileR.GetLength()%512){
			//利用MZ头记录的文件头的节数（一节16BYTE） 来去掉MZ文件头
            fileR.Seek(8, CFile::begin);
			fileR.Read((char *)str, 1);
			temp = str[0];
			fileR.Read((char *)str, 1);
			temp += str[0]*256;
			temp *= 16;
			fileR.Seek(temp, CFile::begin);
		}
		else
			fileR.SeekToBegin();
	}
	else
		fileR.SeekToBegin();
    
    fileW.Seek((m_shanqu - 1)*512, 0);
	while(1){
		temp = fileR.Read(str, 512);
		if(temp==0){
			break;
		}

		if(temp == 512){
			fileW.Write(str, 512);
		}
		else{
			fileW.Write(str, temp);
			break;
		}
	}

	/*不将后面清0比较方便
	temp = fileW.GetLength() - fileW.GetPosition();
	char * ch = new char[temp];
	memset(ch, 0, temp);
	fileW.Write(ch, temp);
	*/

	fileR.Close();
	fileW.Close();
	GetDlgItem(IDC_STATIC1)->ShowWindow(SW_SHOW);
	UpdateWindow();
	Sleep(1000);   //偷下懒  o(∩_∩)o
	GetDlgItem(IDC_STATIC1)->ShowWindow(false);
}

LRESULT CMyDlg::OnTray(WPARAM wParam,LPARAM lParam)
{
	switch (lParam)
	{
	case WM_LBUTTONDOWN:
		if(ShowWindow(SW_SHOW))
			ShowWindow(SW_HIDE);
		break;
		
	case WM_RBUTTONDOWN:

		m_cMenu.LoadMenu(IDR_MENU1);
		m_pPopup=m_cMenu.GetSubMenu(0);
		GetCursorPos(&m_cPoint);

		SetForegroundWindow();
		m_pPopup->TrackPopupMenu
			(TPM_LEFTALIGN	| TPM_RIGHTBUTTON,m_cPoint.x, m_cPoint.y,this);	
		break;
		
	default: 
		break;
	}

	return 0;
}

void CMyDlg::OnExit() 
{
	Shell_NotifyIcon(NIM_DELETE,&m_stTray); 
	::PostQuitMessage(0);
}

void CMyDlg::OnAbout() 
{
	CAboutDlg dlgAbout;
	dlgAbout.DoModal();
}

void CMyDlg::OnRadio1() 
{
	
	
}

void CMyDlg::OnRadio2() 
{
	
}

void CMyDlg::OnRadio3() 
{

}

void CMyDlg::OnButtonFloppy() 
{
	GetDlgItem(IDC_EDIT4)->GetWindowText(m_write);
	
	if(m_write.IsEmpty()){
		AfxMessageBox("请指定映像文件!  ", MB_ICONWARNING);
        return;
	}

	CFile fileW;
	if(!fileW.Open(m_write, CFile::modeReadWrite | CFile::typeBinary)){
		AfxMessageBox("文件不存在或者被其他程序被占用!  ", MB_ICONWARNING);
        return;
	}

	fileW.SetLength(1440*1024);
	fileW.Close();
	GetDlgItem(IDC_STATIC2)->ShowWindow(SW_SHOW);
	UpdateWindow();
	Sleep(1000); 
	GetDlgItem(IDC_STATIC2)->ShowWindow(false);	
}

/*
typedef struct _IMAGE_DOS_HEADER { // DOS的.EXE头部
	USHORT e_magic; // 魔术数字
	USHORT e_cblp; // 文件最后页的字节数
	USHORT e_cp; // 文件页数
	USHORT e_crlc; // 重定义元素个数
	USHORT e_cparhdr; // 头部尺寸，以段落为单位
	USHORT e_minalloc; // 所需的最小附加段
	USHORT e_maxalloc; // 所需的最大附加段
	USHORT e_ss; // 初始的SS值（相对偏移量）
	USHORT e_sp; // 初始的SP值
	USHORT e_csum; // 校验和
	USHORT e_ip; // 初始的IP值
	USHORT e_cs; // 初始的CS值（相对偏移量）
	USHORT e_lfarlc; // 重分配表文件地址
	USHORT e_ovno; // 覆盖号
	USHORT e_res[4]; // 保留字
	USHORT e_oemid; // OEM标识符（相对e_oeminfo）
	USHORT e_oeminfo; // OEM信息
	USHORT e_res2[10]; // 保留字
	LONG e_lfanew; // 新exe头部的文件地址
} IMAGE_DOS_HEADER, *PIMAGE_DOS_HEADER;
*/

//读取dos文件头信息
void CMyDlg::ReadDosHeader(const BYTE* pBuffer)  
{
	std::ostringstream strInfo;

	PIMAGE_DOS_HEADER SrcImageDosHeader = (PIMAGE_DOS_HEADER)pBuffer;
	if (SrcImageDosHeader->e_magic != IMAGE_DOS_SIGNATURE)  
	{
		strInfo << "not a dos program.";
	}  
	else
	{
		strInfo << "dos header size:" << sizeof(*SrcImageDosHeader) << '\n';
		strInfo << "魔术数字:" << SrcImageDosHeader->e_magic << '\n';
		strInfo << "文件最后页的字节数:" << SrcImageDosHeader->e_cblp << '\n';
		strInfo << "文件页数:" << SrcImageDosHeader->e_cp << '\n';
		strInfo << "重定义元素个数:" << SrcImageDosHeader->e_crlc << '\n';
		strInfo << "头部尺寸，以段落为单位:" << SrcImageDosHeader->e_cparhdr << '\n';
		strInfo << "所需的最小附加段:" << SrcImageDosHeader->e_minalloc<< '\n';
		strInfo << "所需的最大附加段:" << SrcImageDosHeader->e_maxalloc<< '\n';
		strInfo << "初始的SS值（相对偏移量）:" << SrcImageDosHeader->e_ss<< '\n';
		strInfo << "初始的SP值:" << SrcImageDosHeader->e_sp<< '\n';
		strInfo << "校验和:" << SrcImageDosHeader->e_csum<< '\n';
		strInfo << "初始的IP值:" << SrcImageDosHeader->e_ip<< '\n';
		strInfo << "初始的CS值（相对偏移量）:" << SrcImageDosHeader->e_cs<< '\n';
		strInfo << "重分配表文件地址:" << SrcImageDosHeader->e_lfarlc<< '\n';
		strInfo << "覆盖号:" << SrcImageDosHeader->e_ovno<< '\n';
		strInfo << "OEM标识符:" << SrcImageDosHeader->e_oemid<< '\n';
		strInfo << "OEM信息:" << SrcImageDosHeader->e_oeminfo<< '\n';
		strInfo << "新exe头部的文件地址:" << SrcImageDosHeader->e_lfanew<< '\n';
	}
	m_fileInfo.SetWindowText(strInfo.str().c_str());
}