#ifndef CONDITIONVARIABLE_H
#define CONDITIONVARIABLE_H
#include <pthread.h>
#include <stdexcept>
#include "mutex.h"

class ConditionVariable
{
private:
    Mutex           m_mutex;
    pthread_cond_t  m_cond;

    ConditionVariable(const ConditionVariable&);
    ConditionVariable& operator=(const ConditionVariable&);

public:
    ConditionVariable()
    {
        int const res=pthread_cond_init(&m_cond, NULL);
        if(res)
        {
            throw std::runtime_error("pthread_cond_init failed");
        }
    }

    ~ConditionVariable()
    {
        pthread_cond_destroy(&m_cond);
    }

    void wait()
    {
        pthread_cond_wait(&m_cond, m_mutex.nativeHandle());
    }

    void notifyOne()
    {
        pthread_cond_signal(&m_cond);
    }

    void notifyAll()
    {
        pthread_cond_broadcast(&m_cond);
    }

    Mutex& mutex()
    {
        return m_mutex;
    }
};

#endif // CONDITIONVARIABLE_H
