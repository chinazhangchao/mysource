QString m_htmlString;
m_htmlString = m_htmlString.replace( "\r", "" );
m_htmlString = m_htmlString.replace( "\n", "" );
m_htmlString = m_htmlString.replace( "&quot;", "\"" );
m_htmlString = m_htmlString.replace( "&amp;", "&" );
m_htmlString = m_htmlString.replace( "\\u003C", "<" );
m_htmlString = m_htmlString.replace( "\\", "" );
