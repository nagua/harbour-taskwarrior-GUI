#include "taskwatcher.h"
#include <QProcessEnvironment>
#include <QDebug>

TaskWatcher::TaskWatcher(QObject *parent) : QObject(parent), m_watch(new QFileSystemWatcher(this))
{
    QString home = QProcessEnvironment::systemEnvironment().value("HOME");
    QString taskfile = home + "/.task/undo.data";
    if(!m_watch->addPath(taskfile))
        qDebug() << "Could not watch file taskfile: " << taskfile;
    connect(m_watch, &QFileSystemWatcher::fileChanged, this, &TaskWatcher::fileHasChanged);
}

void TaskWatcher::fileHasChanged(const QString& /*file*/)
{
    emit TasksChanged();
}


