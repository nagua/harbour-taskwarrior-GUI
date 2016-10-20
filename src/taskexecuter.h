#ifndef TASKEXECUTER_H
#define TASKEXECUTER_H

#include <QObject>
#include <QProcess>
#include <QTimer>
#include <QVariant>

class TaskExecuter : public QObject
{
    Q_OBJECT
public:
    explicit TaskExecuter(QObject *parent = 0);
    Q_INVOKABLE void executeTask(QStringList arguments, QString std_in = "");

private:
    QProcess    *m_process;
    QTimer      *m_timer;

signals:
    void resultIsReady(QVariant status, QVariant vstdout, QVariant vstderr);

public slots:
    void finished(int exitCode, QProcess::ExitStatus status);
    void timeout();
};

#endif // TASKEXECUTER_H
