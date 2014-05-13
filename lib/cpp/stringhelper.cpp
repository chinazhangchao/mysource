/*
 * =====================================================================================
 *
 *       Filename:  stringhelper.cpp
 *
 *    Description:  :
 *
 *        Version:  1.0
 *        Created:  2014/04/24  9:42:02
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Charles Zhang(), 
 *   Organization:  
 *
 * =====================================================================================
 */
#include <string>
#include <vector>

std::string& replace_all( std::string& str, const std::string& old_value,
                const std::string& new_value )
{
        std::string::size_type pos( 0 );
        while ( ( pos = str.find( old_value ) ) != std::string::npos )
        {
                str.replace( pos, old_value.length(), new_value );
        }
        return str;
}

std::string& replace_all_distinct( std::string& str, const std::string& old_value,
                const std::string& new_value )
{
        for ( std::string::size_type pos( 0 ); pos != std::string::npos;
                        pos += new_value.length() )
        {
                if ( ( pos = str.find( old_value, pos ) ) != std::string::npos )
                {
                        str.replace( pos, old_value.length(), new_value );
                }
                else
                {
                        break;
                }
        }
        return str;
}

std::vector<std::string> split( std::string str, const std::string &pattern )
{
        std::string::size_type pos;
        std::vector<std::string> result;
        str += pattern; //扩展字符串以方便操作
        int size = str.size();
        int i = 0;

        while ( i < size )
        {
                pos = str.find( pattern, i );
                if ( pos != std::string::npos )
                {
                        std::string s = str.substr( i, pos - i );
                        if (!s.empty())
                        {
                                result.push_back( s );
                        }
                        i = pos + pattern.size();
                }
                else
                        break;
        }

        return result;
}

