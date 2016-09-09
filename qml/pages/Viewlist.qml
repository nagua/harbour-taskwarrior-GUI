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
import org.nemomobile.configuration 1.0
import "../lib/storage.js" as DB


Page {
    id: page

    function copyViewModel(view) {
        return {lid: view.lid, page: view.page, name: view.name, query: view.query, section: view.section};
    }

    SilicaListView {
        id: listView
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: "Reset lists"
                onClicked: DB.recreateDB()
            }

            MenuItem {
                text: qsTr("Add View")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("AddView.qml"));
                    dialog.accepted.connect(function() {
                        var item = {page: "Tasklist.qml", name: dialog.name, query: dialog.query, section: dialog.section}
                        DB.addView(item);
                        pagesModel.append(item)
                    });
                }
            }
        }

        ListModel {
            id: pagesModel

            ListElement {
                lid: -1
                page: "Tasklist.qml"
                name: "All tasks"
                query: "status:pending"
                section: "Smart"
            }

            ListElement {
                lid: -1
                page: "Tasklist.qml"
                name: "Due today"
                query: "status:pending due:today"
                section: "Smart"
            }

            Component.onCompleted: {
                var views = DB.readViews();
                for(var i = 0; i < views.length; ++i) {
                    var item = views[i];
                    item.page = "Tasklist.qml";
                    pagesModel.append(item);
                }
            }
        }

        header: Column {
            width: parent.width
            PageHeader {
                width: parent.width
                title: "Taskwarrior"
            }
            Row {
                width: parent.width
                TextField {
                    id: query
                    width: parent.width - 70
                    label: "query"
                }
                IconButton {
                    width: 20
                    icon.source: "image://theme/icon-m-enter"
                    onClicked: {
                        taskWindow.taskArguments = query.text;
                        pageStack.navigateBack();
                    }
                }
            }
        }

        section {
            property: "section"
            delegate: SectionHeader {
                text: section
            }
        }

        model: pagesModel
        delegate: ListItem {
            width: listView.width
            Label {
                id: firstName
                text: model.name
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.horizontalPageMargin
            }
            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Edit")
                    onClicked: {
                        var m = copyViewModel(model);
                        var dialog = pageStack.push(Qt.resolvedUrl("AddView.qml"), {name: m.name, query: m.query, section: m.section});;
                        dialog.accepted.connect(function() {
                            m.name = dialog.name
                            m.query = dialog.query
                            m.section = dialog.section
                            pagesModel.set(model.index, m);
                            DB.editView(m);
                        });
                    }
                }
                MenuItem {
                    text: qsTr("Delete")
                    onClicked: {
                        if(model.lid >= 0)
                        {
                            DB.deleteView(model);
                            pagesModel.remove(model.index);
                        }
                    }
                }
            }

            onClicked: {
                taskWindow.taskArguments = model.query;
                pageStack.navigateBack();
            }
        }

        VerticalScrollDecorator {}
    }
}


