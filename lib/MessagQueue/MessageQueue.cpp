#include "MessageQueue.h"

MessageQueue MessageQueue::msgQueue;

void MessageQueue::PutMessage(const QSharedPointer<QString> &s)
{
    QMutexLocker qlocker(&m_queueMutex);
    m_messageQueue.push_back(s);
    m_msgCount.release();
}

QSharedPointer<QString> MessageQueue::GetMessage()
{
    m_msgCount.acquire();
    QMutexLocker qlocker(&m_queueMutex);
    return m_messageQueue.takeFirst();
}
