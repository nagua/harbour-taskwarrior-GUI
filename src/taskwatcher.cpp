#include "taskwatcher.h"
#include <QProcessEnvironment>
#include <QDebug>

TaskWatcher::TaskWatcher(QObject *parent) : QObject(parent),
    m_watch(new QFileSystemWatcher(this)),
    m_timer(new QTimer(this))
{
    QString home = QProcessEnvironment::systemEnvironment().value("HOME");
    QString taskfile = home + "/.task/undo.data";
    if(!m_watch->addPath(taskfile))
        qDebug() << "Could not watch file taskfile: " << taskfile;

    connect(m_watch, &QFileSystemWatcher::fileChanged, this, &TaskWatcher::fileHasChanged);
    connect(m_timer, &QTimer::timeout, this, &TaskWatcher::timeout);
    m_timer->setSingleShot(true);
    m_timer->setInterval(200);
}

void TaskWatcher::fileHasChanged(const QString& /*file*/)
{
    m_timer->start();
}

void TaskWatcher::timeout()
{
    emit TasksChanged();
}


