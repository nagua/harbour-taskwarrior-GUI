#ifndef TASKWATCHER_H
#define TASKWATCHER_H

#include <QObject>
#include <QFileSystemWatcher>
#include <QTimer>

class TaskWatcher : public QObject
{
    Q_OBJECT
public:
    explicit TaskWatcher(QObject *parent = 0);

private:
    QFileSystemWatcher  *m_watch;
    QTimer              *m_timer;

signals:
    void TasksChanged();

public slots:
    void fileHasChanged(const QString &/*file*/);
    void timeout();
};

#endif // TASKWATCHER_H
