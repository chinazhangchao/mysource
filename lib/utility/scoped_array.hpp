#ifndef SCOPED_ARRAY_HPP
#define SCOPED_ARRAY_HPP

#include <cassert>			// for std::assert
#include <cstddef>          // for std::size_t

template<class T> class ScopedArray // noncopyable
{
public:

    explicit ScopedArray(std::size_t arraySize) : m_size(arraySize), m_px(NULL) // never throws
    {
			std::assert(arraySize > 0);
			m_px = new T[arraySize];
    }

    ~ScopedArray() // never throws
    {
      delete []m_px;
    }

    T & operator[](std::size_t i) const // never throws
    {
			std::assert(NULL != m_px);
			std::assert(i < m_size);
      return m_px[i];
    }

    T * get() const // never throws
    {
      return m_px;
    }

	std::size_t size() const
	{
		return m_size;
	}

private:

	T * m_px;
	std::size_t m_size;

	ScopedArray(ScopedArray const &);
	ScopedArray & operator=(ScopedArray const &);

	void operator==( ScopedArray const& ) const;
	void operator!=( ScopedArray const& ) const;
};

#endif  // #ifndef SCOPED_ARRAY_HPP
