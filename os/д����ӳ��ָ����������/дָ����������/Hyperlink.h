/*
这是一个功能很弱的超链接类，派生自CStatic，

使用步骤：
1. 将Hyperlink添加到工程中
2. 在父窗口放置一个静态文本控件；
3. 给控件关联一个Hyperlink对象
4. 调用SetHyperlink设置链接和字体颜色，函数原型 void SetHyperlink(char *link = "about:blank", bool ulAlways = false, bool ulNon = false, COLORREF cNormal = RGB(0,0,0), COLORREF cMMOVE = RGB(0,0,255), COLORREF cLDOWN = RGB(255,0,0))
   参数：
   link       要打开的链接，默认"about:blank"
   ulAlways   是否总是以下划线显示超链接，默认否，鼠标不在链接上时没有下划线
   ulNon      是否总是不以下划线显示超链接，默认否，鼠标在链接上时有下划线
   cNormal    通常情况下字体颜色的RGB值，默认黑色
   cMMOVE     鼠标移动（左键没有按下）字体颜色的RGB值，默认蓝色
   cLDOWN     左键按下字体颜色的RGB值，默认红色

   因为ulAlways和ulNon不能同时为真，如果给出的参数同时为真，那么ulNon会被丢弃

   所的参数都有默认值，调用的时候是可以都不传参的（但是没理由不给link传参吧）

5. 如果想要设置静态文本控件的背景色，可以调用 void SetBackground(COLORREF cBackground)

6. 另外没有提供更多的设置了，如果不合意，请动手修改代码
7. 有问题请联系 liuqizealot@163.com 或到 http://hi.baidu.com/liuqizealot 留言
*/
#if !defined(AFX_Hyperlink_H__5F72CC11_382F_4B84_88AB_BA49F5B701DF__INCLUDED_)
#define AFX_Hyperlink_H__5F72CC11_382F_4B84_88AB_BA49F5B701DF__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Hyperlink.h : header file
//

#ifndef IDC_HAND
#define IDC_HAND MAKEINTRESOURCE(32649)
#endif

/////////////////////////////////////////////////////////////////////////////
// CHyperlink window

class CHyperlink : public CStatic
{
// Construction
public:
	CHyperlink();
	void SetBackground(COLORREF cBackground);
	void SetHyperlink(char *link = "about:blank", bool ulAlways = false, bool ulNon = false, COLORREF cNormal = RGB(0,0,0), COLORREF cMMOVE = RGB(0,0,255), COLORREF cLDOWN = RGB(255,0,0));	
    CRect m_cRectOrg;  //窗口相对父窗口原始位置
	CRect m_cRectLow;  //右下移动1像素的位置
// Attributes
public:

protected:
	bool m_bULAlways;
	bool m_bULNon;
	bool m_bFirst;

	char* m_chHyperlink;
	COLORREF m_ulTextNormal;  //通常情况下字体颜色的RGB值
	COLORREF m_ulTextMMOVE;   //鼠标移动（左键没有按下）字体颜色的RGB值
	COLORREF m_ulTextLDOWN;   //左键按下字体颜色的RGB值
	COLORREF m_ulColorShow;   //需要显示的颜色
	COLORREF m_ulBack;        //背景色
	
	CFont m_cFontUnderline; //下划线字体
	CFont m_cFontNormal;   //通常情况下的字体

	bool m_bMouseInside;  //是否在控件内
	bool m_bSetBack;   //是否设置了背景色

	HBRUSH m_hBrush;   //背景画刷
	bool m_bAlrSetBrush;  //是否已经设置过背景画刷
	bool m_bMouseLeave;  //是否鼠标离开事件
	bool m_bRunIE;  //防止连续的点击打开多个网页

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CHyperlink)
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CHyperlink();

	// Generated message map functions
protected:
	//{{AFX_MSG(CHyperlink)
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	afx_msg HBRUSH CtlColor(CDC* pDC, UINT nCtlColor);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnLButtonDblClk(UINT nFlags, CPoint point);
	afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnRButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnRButtonDblClk(UINT nFlags, CPoint point);
	//}}AFX_MSG
	//afx_msg void OnMouseLeave(WPARAM wp,LPARAM lp); 
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnMouseLeave();
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_Hyperlink_H__5F72CC11_382F_4B84_88AB_BA49F5B701DF__INCLUDED_)
