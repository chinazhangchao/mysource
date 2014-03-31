// Hyperlink.cpp : implementation file
//

#include "stdafx.h"
#include "Hyperlink.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CHyperlink

CHyperlink::CHyperlink()
{
	SetHyperlink();
	m_bMouseInside = false;
	m_bFirst = true;
	m_bAlrSetBrush = false;
	m_bMouseLeave = false;
	m_bRunIE = false;
}


void CHyperlink::SetHyperlink(char *link, bool ulAlways, bool ulNon, COLORREF cNormal, COLORREF cMMOVE, COLORREF cLDOWN)
{
	m_chHyperlink = new char[strlen(link)+1];
	strcpy(m_chHyperlink, link);

	m_ulTextNormal = cNormal;
	m_ulTextMMOVE = cMMOVE;
	m_ulTextLDOWN = cLDOWN;

	m_ulColorShow = cNormal;

	m_bULAlways = ulAlways;

	if(!ulAlways)   //m_bULAlways和m_bULNon不能同时为真
		m_bULNon = ulNon;
	else
		m_bULNon = false;
}

void CHyperlink::SetBackground(COLORREF cBackground)
{
	m_bAlrSetBrush = true;
	m_hBrush = CreateSolidBrush(cBackground);
}

CHyperlink::~CHyperlink()
{
	delete m_chHyperlink;
}


BEGIN_MESSAGE_MAP(CHyperlink, CStatic)
	//{{AFX_MSG_MAP(CHyperlink)
	ON_WM_LBUTTONDOWN()
	ON_WM_MOUSEMOVE()
	ON_WM_CTLCOLOR_REFLECT()
	ON_WM_LBUTTONUP()
	ON_WM_LBUTTONDBLCLK()
	ON_WM_RBUTTONDOWN()
	ON_WM_RBUTTONUP()
	ON_WM_RBUTTONDBLCLK()
	//}}AFX_MSG_MAP
	//ON_MESSAGE(WM_MOUSELEAVE,OnMouseLeave)
	ON_WM_MOUSELEAVE()
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CHyperlink message handlers

HBRUSH CHyperlink::CtlColor(CDC* pDC, UINT nCtlColor) 
{
	if(m_bFirst){
		m_bFirst = false;

		ModifyStyle(0,SS_NOTIFY);  //响应通知消息

		LOGFONT LogFont;  //设置字体
		GetFont()->GetLogFont(&LogFont);

		if(m_bULAlways)
			LogFont.lfUnderline = true;

		m_cFontNormal.CreateFontIndirect(&LogFont);
		SetFont(&m_cFontNormal, false);
		Invalidate();  //这里需要第一次调用执行完以后刷新一次

		if(!m_bULNon)
			LogFont.lfUnderline = true;
		
		m_cFontUnderline.CreateFontIndirect(&LogFont);

		if(!m_bAlrSetBrush)
			m_hBrush = (HBRUSH)GetStockObject(NULL_BRUSH);

		GetWindowRect(&m_cRectOrg);   //确定位置
		GetParent()->ScreenToClient(&m_cRectOrg);

		m_cRectLow = m_cRectOrg;
		m_cRectLow.OffsetRect(1, 1);  //注释掉这一行超链接位置就不会动
	}

	pDC->SetTextColor(m_ulColorShow);

	if( m_bMouseLeave ){   //这里没想到更好的方法，有好的建议请告知
		pDC->SetBkMode(OPAQUE);
		return NULL;
	}
	pDC->SetBkMode(TRANSPARENT);
		
	// TODO: Return a non-NULL brush if the parent's handler should not be called
	return m_hBrush;
}

void CHyperlink::OnMouseMove(UINT nFlags, CPoint point) 
{
	CStatic::OnMouseMove(nFlags, point);
	
	::SetCursor(::LoadCursor(NULL,IDC_HAND));

	if(!m_bMouseInside)   
	{//鼠标第一次移入窗口时，请求一个WM_MOUSELEAVE消息  
		m_bMouseInside = true;
		m_ulColorShow = m_ulTextMMOVE;

		TRACKMOUSEEVENT tme;   
		tme.cbSize  = sizeof(tme);   
		tme.hwndTrack = m_hWnd;   
		tme.dwFlags = TME_LEAVE;   
		_TrackMouseEvent(&tme);   
	
		MoveWindow(m_cRectOrg);
		SetFont(&m_cFontUnderline);
	}
}

//void CHyperlink::OnMouseLeave(WPARAM wp,LPARAM lp)   
//{
//	m_bMouseInside = false;
//	m_ulColorShow = m_ulTextNormal;
//	//::SetCursor(::LoadCursor(NULL,IDC_ARROW));
//	if( !(m_bULAlways || m_bULNon) ){ //如果不总是有（或没有）下划线，那么就得去掉下划线
//		m_bMouseLeave = true;   
//		SetFont(&m_cFontNormal);  //这里必须重绘一次
//		m_bMouseLeave = false;
//	}
//	MoveWindow(m_cRectOrg);
//	RedrawWindow();
//} 

void CHyperlink::OnLButtonDown(UINT nFlags, CPoint point) 
{
	//左键按下，超链接变色并右下各移动1像素
	::SetCursor(::LoadCursor(NULL,IDC_HAND));

	m_ulColorShow = m_ulTextLDOWN;
	MoveWindow(m_cRectLow);
	RedrawWindow();

	CStatic::OnLButtonDown(nFlags, point);
}

DWORD WINAPI bRunIEChange(PVOID pvParam)
{
	Sleep(2000);
	*(bool*)pvParam = false;
	return 0;
}

void CHyperlink::OnLButtonUp(UINT nFlags, CPoint point) 
{
	//左键放开，打开链接，超链接位置返回
	::SetCursor(::LoadCursor(NULL,IDC_HAND));

	m_ulColorShow = m_ulTextMMOVE;
	MoveWindow(m_cRectOrg);
	RedrawWindow();

	//用IE打开链接，2秒内的点击不重复打开，要去掉此限制或用别的浏览器打开可以修改这里
	if(!m_bRunIE){
		m_bRunIE = true;

		DWORD dwThreadId;
		HANDLE hThread;	
		hThread = CreateThread(NULL, 0,bRunIEChange , (PVOID)&m_bRunIE, 0, &dwThreadId);
		if(hThread != NULL)
			CloseHandle(hThread);

		::ShellExecute(m_hWnd, "open", "IEXPLORE.EXE", m_chHyperlink, NULL,SW_MAXIMIZE);
	}

	CStatic::OnLButtonUp(nFlags, point);
}

//后面对LButtonDblClk和RBUTTON的所有消息响应只是为了让光标不发生变化，因此行为一致
void CHyperlink::OnLButtonDblClk(UINT nFlags, CPoint point) 
{
	::SetCursor(::LoadCursor(NULL,IDC_HAND));
	
	CStatic::OnLButtonDblClk(nFlags, point);
}

void CHyperlink::OnRButtonDown(UINT nFlags, CPoint point) 
{
	::SetCursor(::LoadCursor(NULL,IDC_HAND));
	
	CStatic::OnRButtonDown(nFlags, point);
}

void CHyperlink::OnRButtonUp(UINT nFlags, CPoint point) 
{
	::SetCursor(::LoadCursor(NULL,IDC_HAND));
	
	CStatic::OnRButtonUp(nFlags, point);
}

void CHyperlink::OnRButtonDblClk(UINT nFlags, CPoint point) 
{
	::SetCursor(::LoadCursor(NULL,IDC_HAND));
	
	CStatic::OnRButtonDblClk(nFlags, point);
}


void CHyperlink::OnMouseLeave()
{
	// TODO: Add your message handler code here and/or call default
	m_bMouseInside = false;
	m_ulColorShow = m_ulTextNormal;
	//::SetCursor(::LoadCursor(NULL,IDC_ARROW));
	if( !(m_bULAlways || m_bULNon) ){ //如果不总是有（或没有）下划线，那么就得去掉下划线
		m_bMouseLeave = true;   
		SetFont(&m_cFontNormal);  //这里必须重绘一次
		m_bMouseLeave = false;
	}
	MoveWindow(m_cRectOrg);
	RedrawWindow();

	CStatic::OnMouseLeave();
}
