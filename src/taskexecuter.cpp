#include "taskexecuter.h"
#include <QDebug>

TaskExecuter::TaskExecuter(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{

}

QString TaskExecuter::executeTask(QStringList arguments)
{
    QString programm = "task";
    m_process->start(programm, arguments);
    m_process->waitForFinished();
    QByteArray bytes = m_process->readAllStandardOutput();
    QString str(bytes);
    return str;
}
