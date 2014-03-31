/*
����һ�����ܺ����ĳ������࣬������CStatic��

ʹ�ò��裺
1. ��Hyperlink��ӵ�������
2. �ڸ����ڷ���һ����̬�ı��ؼ���
3. ���ؼ�����һ��Hyperlink����
4. ����SetHyperlink�������Ӻ�������ɫ������ԭ�� void SetHyperlink(char *link = "about:blank", bool ulAlways = false, bool ulNon = false, COLORREF cNormal = RGB(0,0,0), COLORREF cMMOVE = RGB(0,0,255), COLORREF cLDOWN = RGB(255,0,0))
   ������
   link       Ҫ�򿪵����ӣ�Ĭ��"about:blank"
   ulAlways   �Ƿ��������»�����ʾ�����ӣ�Ĭ�Ϸ���겻��������ʱû���»���
   ulNon      �Ƿ����ǲ����»�����ʾ�����ӣ�Ĭ�Ϸ������������ʱ���»���
   cNormal    ͨ�������������ɫ��RGBֵ��Ĭ�Ϻ�ɫ
   cMMOVE     ����ƶ������û�а��£�������ɫ��RGBֵ��Ĭ����ɫ
   cLDOWN     �������������ɫ��RGBֵ��Ĭ�Ϻ�ɫ

   ��ΪulAlways��ulNon����ͬʱΪ�棬��������Ĳ���ͬʱΪ�棬��ôulNon�ᱻ����

   ���Ĳ�������Ĭ��ֵ�����õ�ʱ���ǿ��Զ������εģ�����û���ɲ���link���ΰɣ�

5. �����Ҫ���þ�̬�ı��ؼ��ı���ɫ�����Ե��� void SetBackground(COLORREF cBackground)

6. ����û���ṩ����������ˣ���������⣬�붯���޸Ĵ���
7. ����������ϵ liuqizealot@163.com �� http://hi.baidu.com/liuqizealot ����
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
    CRect m_cRectOrg;  //������Ը�����ԭʼλ��
	CRect m_cRectLow;  //�����ƶ�1���ص�λ��
// Attributes
public:

protected:
	bool m_bULAlways;
	bool m_bULNon;
	bool m_bFirst;

	char* m_chHyperlink;
	COLORREF m_ulTextNormal;  //ͨ�������������ɫ��RGBֵ
	COLORREF m_ulTextMMOVE;   //����ƶ������û�а��£�������ɫ��RGBֵ
	COLORREF m_ulTextLDOWN;   //�������������ɫ��RGBֵ
	COLORREF m_ulColorShow;   //��Ҫ��ʾ����ɫ
	COLORREF m_ulBack;        //����ɫ
	
	CFont m_cFontUnderline; //�»�������
	CFont m_cFontNormal;   //ͨ������µ�����

	bool m_bMouseInside;  //�Ƿ��ڿؼ���
	bool m_bSetBack;   //�Ƿ������˱���ɫ

	HBRUSH m_hBrush;   //������ˢ
	bool m_bAlrSetBrush;  //�Ƿ��Ѿ����ù�������ˢ
	bool m_bMouseLeave;  //�Ƿ�����뿪�¼�
	bool m_bRunIE;  //��ֹ�����ĵ���򿪶����ҳ

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
