#ifndef TASKWATCHER_H
#define TASKWATCHER_H

#include <QObject>
#include <QFileSystemWatcher>

class TaskWatcher : public QObject
{
    Q_OBJECT
public:
    explicit TaskWatcher(QObject *parent = 0);

private:
    QFileSystemWatcher *m_watch;

signals:
    void TasksChanged();

public slots:
    void fileHasChanged(const QString &/*file*/);
};

#endif // TASKWATCHER_H
