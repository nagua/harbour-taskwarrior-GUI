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
import eu.nagua 1.0


Page {
    id: page
    property string args

    TaskExecuter {
        id: executer
    }

    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Load Data")
                onClicked: getData()
            }
        }

        SilicaListView {
            id: listView
            model: ListModel {
                id: taskModel
                property bool ready: false
            }

            header: PageHeader {
                title: qsTr("Task list")
            }

            opacity: taskModel.ready ? 1.0 : 0.0
            Behavior on opacity { FadeAnimation {} }

            anchors.fill: parent
            delegate: BackgroundItem {
                id: delegate
                property int tid: model.id;

                Label {
                    x: Theme.paddingLarge
                    text: description
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("DetailView.qml"), {data: model});
                }
            }

            VerticalScrollDecorator {}
        }
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

    Component.onCompleted: getData();

    function getData()
    {
        // Get arguments from MainPage and split them on whitespace
        // also add "export"
        var args = page.args.match(/(?:[^\s"]+|"[^"]*")+/g);
        args.push("export");

        // Run taskwarrior
        var task_json_str = executer.executeTask(args);
        console.log(task_json_str);

        // Parse JSON Data
        var task_data = JSON.parse(task_json_str);
        // Sort data by urgency
        task_data.sort(function(a,b){ return b.urgency - a.urgency; });

        // Clear model and add new items
        taskModel.clear();
        for(var i = 0; i < task_data.length; i++) {
            taskModel.append( task_data[i] );
        }
        taskModel.ready = true;
    }
}





