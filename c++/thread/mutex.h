#ifndef MUTEX_H
#define MUTEX_H
#include <pthread.h>
#include <stdexcept>
#include "lockguard.h"

class Mutex
{
private:
    Mutex(Mutex const&);
    Mutex& operator=(Mutex const&);
    pthread_mutex_t m;
public:
    Mutex()
    {
        int const res = pthread_mutex_init(&m, NULL);
        if (res)
        {
            throw std::runtime_error("pthread_mutex_init failed");
        }
    }
    ~Mutex()
    {
        pthread_mutex_destroy(&m);
    }

    void lock()
    {
        pthread_mutex_lock(&m);
    }

    void unlock()
    {
        pthread_mutex_unlock(&m);
    }

    pthread_mutex_t* nativeHandle()
    {
        return &m;
    }

    typedef LockGuard<Mutex> ScopeLock;
};
#endif // MUTEX_H
