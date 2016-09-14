#include "taskwatcher.h"

TaskWatcher::TaskWatcher(QObject *parent) : QObject(parent), m_watch(new QFileSystemWatcher(this))
{
    m_watch->addPath("/home/nemo/.task/undo.data");
    connect(m_watch, &QFileSystemWatcher::fileChanged, this, &TaskWatcher::fileHasChanged);
}

void TaskWatcher::fileHasChanged(const QString& /*file*/)
{
    emit TasksChanged();
}


