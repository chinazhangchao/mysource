#include <QCoreApplication>
#include "MessageQueue.h"
#include "producer.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QString path = QCoreApplication::applicationDirPath();
    Producer p1;
    p1.start();
    Producer p2;
    p2.start();
    MessageQueue &q = MessageQueue::Instance();
    int r = 0;
    QSharedPointer<QString> data;
    while (true)
    {
        data = q.GetMessage();
        printf("out:%s\n", data->toLocal8Bit().data());
//        r = qrand()%10;
//        QThread::msleep(r*100);
    }

    return a.exec();
}
