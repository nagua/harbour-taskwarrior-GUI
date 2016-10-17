#include "taskexecuter.h"
#include <QDebug>

TaskExecuter::TaskExecuter(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{
    connect(m_process, static_cast<void(QProcess::*)(int, QProcess::ExitStatus)>(&QProcess::finished), this, &TaskExecuter::finished);
}

void TaskExecuter::executeTask(QStringList arguments, QString std_in)
{
    if(m_process->state() == QProcess::Running )
        return;

    QString programm = "task";
    m_process->start(programm, arguments);

    if(std_in != "") {
        QByteArray data = std_in.toUtf8();
        m_process->write(data);
        m_process->closeWriteChannel();
    }
}

void TaskExecuter::finished(int exitCode, QProcess::ExitStatus status) {
    if(status == QProcess::NormalExit) {
        QVariant vstdout = QVariant(QString(m_process->readAllStandardOutput()));
        QVariant vstderr = QVariant(QString(m_process->readAllStandardError()));
        QVariant vstatus(exitCode);
        emit resultIsReady(vstatus, vstdout, vstderr);
    } else {
        //assert(true);
    }
}
