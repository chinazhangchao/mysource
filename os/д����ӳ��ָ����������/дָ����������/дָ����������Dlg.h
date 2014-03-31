// 写指定扇区工具Dlg.h : header file
//

#if !defined(AFX_DLG_H__5C09D308_85FE_4092_BC2E_948A8CF2A465__INCLUDED_)
#define AFX_DLG_H__5C09D308_85FE_4092_BC2E_948A8CF2A465__INCLUDED_

#include "hyperlink.h"
#include "afxwin.h"

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CMyDlg dialog

class CMyDlg : public CDialog
{
// Construction
public:
	CMyDlg(CWnd* pParent = NULL);	// standard constructor
// Dialog Data
	//{{AFX_DATA(CMyDlg)
	enum { IDD = IDD_MY_DIALOG };
	int		m_shanqu;
	CString	m_write;
	CString	m_read;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMyDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

	//读取dos文件头信息
	void ReadDosHeader(const BYTE* pBuffer);
// Implementation
protected:
	NOTIFYICONDATA m_stTray;
	CMenu m_cMenu;
	CMenu *m_pPopup;
	CPoint m_cPoint;
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CMyDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	virtual void OnOK();
	virtual void OnCancel();
	afx_msg void OnChangeEdit1();
	afx_msg void OnButtonSrcFile();
	afx_msg void OnButtonDstImg();
	afx_msg void OnButtonWrite();
	afx_msg void OnRadio1();
	afx_msg void OnRadio2();
	afx_msg void OnRadio3();
	afx_msg void OnButtonFloppy();
	//}}AFX_MSG
	afx_msg void OnExit();
	afx_msg void OnAbout();
	afx_msg LRESULT OnTray(WPARAM wParam,LPARAM lParam);
	DECLARE_MESSAGE_MAP()
private:
	CStatic m_fileInfo;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLG_H__5C09D308_85FE_4092_BC2E_948A8CF2A465__INCLUDED_)
