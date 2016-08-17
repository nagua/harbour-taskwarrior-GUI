#ifndef TASKEXECUTER_H
#define TASKEXECUTER_H

#include <QObject>
#include <QProcess>

class TaskExecuter : public QObject
{
    Q_OBJECT
public:
    explicit TaskExecuter(QObject *parent = 0);
    Q_INVOKABLE QString executeTask(QStringList arguments);

private:
    QProcess *m_process;

signals:

public slots:
};

#endif // TASKEXECUTER_H
