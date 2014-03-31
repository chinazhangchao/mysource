#ifndef PRODUCER_H
#define PRODUCER_H

#include <QThread>

class Producer : public QThread
{
    Q_OBJECT
public:
    explicit Producer(QObject *parent = 0);
protected:
    virtual void run();
signals:

public slots:

};

#endif // PRODUCER_H
