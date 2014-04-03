#ifndef SINGLETON_H
#define SINGLETON_H
#include <memory>
#include "thread/mutex.h"

template <class T>
class Singleton
{
public:
    static T& getInstance()
    {
        if (NULL == pInstance.get())
        {
            Mutex::ScopeLock lock(instanceMutex);
            if (NULL == pInstance.get())
                pInstance = std::auto_ptr<T>(new T());
        }

        return (*pInstance);
    }

protected:
    Singleton(){}
    virtual ~Singleton(){}
    
private:
    Singleton(const Singleton&);
    Singleton& operator = (const Singleton&);

    static std::auto_ptr<T> pInstance;
    static Mutex        instanceMutex;
};

template <class T> std::auto_ptr<T> Singleton<T>::pInstance;
template <class T> Mutex Singleton<T>::instanceMutex;

#endif // SINGLETON_H
