#ifndef BARRIER_H
#define BARRIER_H
#include "conditionvariable.h"

class Barrier
{
public:
    Barrier(unsigned int count)
        : m_threshold(count), m_count(count)
    {
        if (count == 0)
            throw std::invalid_argument("count cannot be zero.");
    }

    Barrier(const Barrier&rhs): m_threshold(rhs.m_threshold), m_count(m_threshold){}

    bool wait()
    {
        LockGuard<Mutex> lock(m_cond.mutex());

        if (--m_count == 0)
        {
            m_count = m_threshold;
            m_cond.notifyAll();
            return true;
        }

        m_cond.wait();
        return false;
    }

private:
    Barrier& operator=(const Barrier&);
    ConditionVariable m_cond;
    unsigned int m_threshold;
    unsigned int m_count;
};

#endif // BARRIER_H
