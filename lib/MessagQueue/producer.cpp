#include "producer.h"
#include "MessageQueue.h"

Producer::Producer(QObject *parent) :
    QThread(parent)
{
}

void Producer::run()
{
    MessageQueue &mq = MessageQueue::Instance();
    uint i = 0;
    int r = 0;
    QSharedPointer<QString> data;
    while (true) {
        data.reset(new QString(QString::number(i++)));
        printf("in:%s\n", data->toLocal8Bit().data());
        mq.PutMessage(data);
        r = qrand()%10;
        QThread::msleep(r*100);
    }
}
