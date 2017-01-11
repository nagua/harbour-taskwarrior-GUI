import QtQuick 2.2
import Sailfish.Silica 1.0
import "../lib/utils.js" as UT

Dialog {
    id: dialog
    property var date_value: getToday()
    property var completed

    function doRoundTo15Minutes() {
        if( timePicker.minute % 15 === 0 )
            return;

        var min = timePicker.minute
        timePicker.minute = Math.round(min / 15) * 15;
    }

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

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Format.formatDate(datePicker.date, Formatter.MonthNameStandalone) + " " + datePicker.date.getFullYear()
                font.family: Theme.fontFamilyHeading
                font.pixelSize: Theme.fontSizeLarge
            }

            DatePicker {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                }

                id: datePicker
                date: dialog.date_value
                daysVisible: true
                onDateChanged: completed ? accept() : {}
            }

//            Item {
//                anchors.left: parent.left
//                anchors.right: parent.right
//                height: 20
//            }

            Grid {
                id: grid
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                }

                spacing: Theme.paddingMedium
                columns: 6
                Repeater {
                    model: ListModel {
                        ListElement { name: "- M"; action: 3 }
                        ListElement { name: "- W"; action: 2 }
                        ListElement { name: "- D"; action: 1 }
                        ListElement { name: "+ D"; action: 4 }
                        ListElement { name: "+ W"; action: 5 }
                        ListElement { name: "+ M"; action: 6 }
                    }
                    delegate: Button {
                        text: name
                        width: ( grid.width - (grid.columns-1)*grid.spacing )/grid.columns
                        onClicked: {
                            switch(action) {
                            case 1:
                                datePicker.date = UT.add_days_to_date(datePicker.date, -1);
                                break;
                            case 2:
                                datePicker.date = UT.add_days_to_date(datePicker.date, -7);
                                break;
                            case 3:
                                datePicker.date = UT.add_months_to_date(datePicker.date, -1);
                                break;
                            case 4:
                                datePicker.date = UT.add_days_to_date(datePicker.date, 1);
                                break;
                            case 5:
                                datePicker.date = UT.add_days_to_date(datePicker.date, 7);
                                break;
                            case 6:
                                datePicker.date = UT.add_months_to_date(datePicker.date, 1);
                                break;
                            }
                        }

                    }
                }
            }

            Item {
                anchors.left: parent.left
                anchors.right: parent.right
                height: 20
            }

            Component.onCompleted: {
                completed = true
            }

//            TimePicker {
//                id: timePicker
//                anchors.horizontalCenter: parent.horizontalCenter
//                hour: date_value.getHours()
//                minute: date_value.getMinutes()
//                Label {
//                    anchors {
//                        centerIn: parent
//                    }
//                    text: parent.timeText
//                    font.family: Theme.fontFamilyHeading
//                    font.pixelSize: Theme.fontSizeLarge
//                }
//                //onMinuteChanged: doRoundTo15Minutes()
//            }
        }
    }

    onDone: {
        if ( result == DialogResult.Accepted ) {
            date_value = datePicker.date
            console.log(date_value)
        }
    }

    function getToday() {
        var d = new Date(Date.now());
        d.setHours(0,0,0);
        return d;
    }
}
