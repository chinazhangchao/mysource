#ifndef LOCKGUARD_H
#define LOCKGUARD_H

template<typename Mutex>
class LockGuard
{
private:
    Mutex& m;

    explicit LockGuard(const LockGuard&);
    LockGuard& operator=(const LockGuard&);
public:
    explicit LockGuard(Mutex& m_):
        m(m_)
    {
        m.lock();
    }

    ~LockGuard()
    {
        m.unlock();
    }
};

#endif // LOCKGUARD_H
