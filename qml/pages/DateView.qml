import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    id: dialog
    property var date_value: new Date(Date.now())

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: col.height + head.height
        VerticalScrollDecorator { flickable: flick }

        DialogHeader {
            id: head
        }

        Column {
            id: col
            anchors {
                top: head.bottom
                left: parent.left
                right: parent.right
            }

            spacing: Theme.paddingMedium

            Grid {
                id: grid
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                }

                spacing: Theme.paddingMedium
                columns: 3
                Repeater {
                    model: ListModel {
                        ListElement { name: "today" }
                        ListElement { name: "tomorrow" }
                        ListElement { name: "next week" }
                        /*ListElement { name: "today" }
                        ListElement { name: "tomorrow" }
                        ListElement { name: "next week" }*/
                    }
                    delegate: Button {
                        text: name
                        width: ( grid.width - (grid.columns-1)*grid.spacing )/grid.columns
                    }
                }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: datePicker.dateText
                font.family: Theme.fontFamilyHeading
                font.pixelSize: Theme.fontSizeLarge

            }

            DatePicker {
                id: datePicker
                date: dialog.date_value
            }
            TimePicker {
                id: time
                anchors.horizontalCenter: parent.horizontalCenter
                hour: date_value.getHours()
                minute: date_value.getMinutes()
                Label {
                    anchors {
                        centerIn: parent
                    }
                    text: parent.timeText
                    font.family: Theme.fontFamilyHeading
                    font.pixelSize: Theme.fontSizeLarge
                }

            }

        }
    }
}

