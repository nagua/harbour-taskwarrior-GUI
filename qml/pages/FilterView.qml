import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property var fields: ["Test 1", "Test 2", "Uni", "Universität", "RobotING"]
    property string pageDescription: "Filter for Tag"

    SilicaListView {
        id: listView
        anchors.fill: parent

        header: Column {
            property alias queryText: searchField.text
            property alias textLeftMargin: searchField.textLeftMargin
            height: searchField.height + dialogHeader.height
            width: parent.width

            DialogHeader {
                id: dialogHeader
            }

            SearchField {
                id: searchField
                width: parent.width
                placeholderText: pageDescription

                onTextChanged: testmodel.update()

                Keys.onReturnPressed: {
                    fields.push(text)
                    testmodel.update()
                }
            }
        }

        currentIndex: -1

        model: ListModel {
            id: testmodel

            function update() {
                clear();
                var query = listView.headerItem.queryText.toLowerCase();
                for (var i=0; i<fields.length; i++) {
                    var comp = fields[i].toLowerCase();
                    if (query === "" || comp.indexOf(query) >= 0) {
                        append({name: fields[i]});
                    }
                }
            }
        }

        delegate: BackgroundItem {
            anchors.left: parent.left
            anchors.right: parent.right
            //anchors.leftMargin: searchField.textLeftMargin
            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: name
            }
        }

        Component.onCompleted: model.update()
    }
}

