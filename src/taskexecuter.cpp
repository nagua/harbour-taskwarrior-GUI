#include "taskexecuter.h"
#include <QDebug>

TaskExecuter::TaskExecuter(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{

}

QString TaskExecuter::executeTask(QStringList arguments, QString std_in)
{
    QString programm = "task";
    m_process->start(programm, arguments);

    if(std_in != "") {
        QByteArray data = std_in.toUtf8();
        m_process->write(data);
        m_process->closeWriteChannel();
    }

    m_process->waitForFinished();
    QByteArray bytes = m_process->readAllStandardOutput();
    QString str(bytes);
    return str;
}
