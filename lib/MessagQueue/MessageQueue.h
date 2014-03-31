#ifndef MESSAGE_QUEUE_H
#define MESSAGE_QUEUE_H
#include <QList>
#include <QSharedPointer>
#include <QString>
#include <QSemaphore>
#include <QMutex>

class MessageQueue
{
public:
    static MessageQueue& Instance()
    {
        return msgQueue;
    }
    void PutMessage(const QSharedPointer<QString> &);
    QSharedPointer<QString> GetMessage();
private:
    MessageQueue(){}
    ~MessageQueue(){}
    QSemaphore      m_msgCount;
    QMutex          m_queueMutex;
    QList<QSharedPointer<QString> > m_messageQueue;
    static MessageQueue msgQueue;
};

#endif
