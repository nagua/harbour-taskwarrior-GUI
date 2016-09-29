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
import "../lib/utils.js" as UT


Page {
    id: page

    SilicaListView {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: "Reset lists"
                onClicked: DB.recreateDB()
            }

            MenuItem {
                text: qsTr("Add View")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("DetailView.qml"));
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
                name: "Pending"
                query: "status:pending"
                section: "Smart"
            }

            ListElement {
                lid: -1
                page: "Tasklist.qml"
                name: "Due today"
                query: "+OVERDUE or +DUETODAY"
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
                title: qsTr("Task views")
            }
            Item {
                anchors {
                    left: parent.left
                    right: parent.right
                    rightMargin: Theme.paddingMedium
                }
                height: queryicon.height
                TextField {
                    id: query
                    anchors.left: parent.left
                    anchors.right: queryicon.left
                    label: qsTr("Custom query")
                    placeholderText: qsTr("Enter custom query")

                    Keys.onReturnPressed: {
                        changeView(query.text);
                    }
                }
                IconButton {
                    id: queryicon
                    anchors.right: parent.right
                    icon.source: "image://theme/icon-m-right"
                    onClicked: {
                        changeView(query.text);
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
            Label {
                id: firstName
                text: model.name
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.horizontalPageMargin
            }

            menu: model.lid >= 0 ? context : undefined

            ContextMenu {
                id: context

                MenuItem {
                    text: qsTr("Edit")
                    onClicked: {
                        var m = UT.copyItem(model);
                        var dialog = pageStack.push(Qt.resolvedUrl("DetailView.qml"), {name: m.name, query: m.query, section: m.section});;
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
                        if(model.lid >= 0) {
                            DB.deleteView(model);
                            pagesModel.remove(model.index);
                        }
                    }
                }
            }

            onClicked: {
                changeView(model.query);
            }
        }


        VerticalScrollDecorator {}
    }

    function changeView(args) {
        if(args !== "") {
            taskWindow.taskArguments = args;
            pageStack.navigateBack();
        }
    }
}
