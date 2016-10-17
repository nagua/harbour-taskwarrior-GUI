/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.taskwarrior 1.0
import org.nemomobile.notifications 1.0
import "../lib/utils.js" as UT


Page {
    id: page
    property string taskArguments
    property var date_value: new Date(Date.now())

    TaskExecuter {
        id: executer
    }

    TaskWatcher {
        id: watcher
    }

    Notification {
        id: notification
    }

    SilicaListView {
        id: listView
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Load Data")
                onClicked: executeExport()
            }
            MenuItem {
                text: qsTr("Synchronize")
                onClicked: {
                    executeTask(["sync"]);
                }
            }
            MenuItem {
                text: qsTr("Add Task")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("DetailTask.qml"));
                }
            }
        }

        model: ListModel {
            id: taskModel
            property bool ready: false
        }

        header: PageHeader {
            title: qsTr("Task list")
        }

        opacity: taskModel.ready ? 1.0 : 0.0
        Behavior on opacity { FadeAnimation {} }

        delegate: ListItem {
            id: delegator
            width: parent.width
            property int tid: model.id

            Rectangle {
                anchors.fill: parent
                color: index % 2 == 0 ? "#208799b5" : "transparent"
                Column {
                    id: col
                    height: childrenRect.height
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }


                    Label {
                        width: parent.width
                        text: description
                        font.bold: isOverdue(model.rawData.due)
                        truncationMode: TruncationMode.Fade
                        color: delegator.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }

                    Item {
                        width: parent.width
                        height: childrenRect.height
                        Label {
                            // This is the project field
                            anchors.left: parent.left
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: delegator.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                            text: showProject(model.rawData.project)
                        }
                        Label {
                            // This is the due date field
                            anchors.right: parent.right
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: delegator.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                            text: showDueDate(model.rawData.due)
                        }
                    }
                    //Divider {}

                }
            }

            RemorseItem { id: remorse }

            menu: ContextMenu {
                id: taskcontextmenu
                MenuItem {
                    text: "Done"
                    onClicked: {
                        var timeout = 2000;
                        remorse.execute(delegator, "Marking as done", function() { doneTask(tid) }, timeout);
                    }
                }
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl("DetailTask.qml"), {taskData: model});
            }
        }

        VerticalScrollDecorator {}
    }

    Column {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        BusyIndicator {
            id: ind
            running: !taskModel.ready
            size: BusyIndicatorSize.Large
            anchors.horizontalCenter: parent.horizontalCenter
        }
        InfoLabel {
            opacity: ind.opacity
            text: qsTr("Loading")
        }
    }

    Component.onCompleted: {
        taskWindow.cover.reloadData.connect(executeExport);
        watcher.TasksChanged.connect(executeExport);
        executer.resultIsReady.connect(getTaskOutput);
    }

    onTaskArgumentsChanged: {
        executeExport();
    }

    function executeTask(args) {
        taskModel.ready = false;
        executer.executeTask(args);
    }

    function executeExport() {
        // Get arguments from MainPage and split them on whitespace
        // also add "export"
        var args = taskArguments.match(/(?:[^\s"]+|"[^"]*")+/g);
        args.push("export");

        executeTask(args);
    }

    function getTaskOutput(status, stdout, stderr) {
        console.log(status);
        if (status !== 0) {
            console.log(stderr);
            notify(stderr);
            taskModel.ready = true;
            return;
        }
        console.log(stdout);

        // Parse JSON Data
        var task_data = "";
        try {
            task_data = JSON.parse(stdout);
        }
        catch(err) {
            notify(stdout);
            taskModel.ready = true;
            return;
        }

        // Sort data by urgency
        task_data.sort(function(a,b) {
            var aid = a.id;
            var bid = b.id;
            var au = a.urgency;
            var bu = b.urgency

            if (au === bu) {
                return aid - bid;
            }

            return bu - au;
        });

        taskWindow.coverModel.clear();
        var max_len = task_data.length < 6 ? task_data.length : 6;
        for(var i = 0; i < max_len; i++) {
            taskWindow.coverModel.append(task_data[i]);
        }

        // Clear model and add new items
        taskModel.clear();
        for(var i = 0; i < task_data.length; i++) {
            var json = {};
            json["description"] = task_data[i].description;
            json["urgency"] = task_data[i].urgency;
            json["status"] = task_data[i].status;
            json["entry"] = task_data[i].entry;
            json["uuid"] = task_data[i].uuid;
            json["id"] = task_data[i].id;

            // Add the rest of the data as an addition jsobject so it will not be unified
            // Thus it is usable to reconstruct the task and modify it
            json["rawData"] = task_data[i];
            taskModel.append( json );
        }
        taskModel.ready = true;
    }

    function showProject(project) {
        if (typeof project === "undefined")
            return "Project:"
        return "Project: " + project
    }

    function showDueDate(date) {
        if (typeof date === "undefined")
            return ""

        var js_date = UT.convert_tdate_to_jsdate(date);
        var fo_date = Format.formatDate(js_date, Formatter.DurationElapsedShort);
        return "Due " + fo_date
    }

    function isOverdue(date) {
        if (typeof date === "undefined")
            return ""
        var now = new Date();
        var due = new Date(UT.convert_tdate_to_jsdate(date));
        return (now>=due) ? true : false;
    }

    function doneTask(tid) {
        executeTask([tid.toString(), "done"]);
    }

    function notify(message) {
        notification.previewBody = "Taskwarrior";
        notification.previewSummary = message;
        notification.publish();
    }
}
