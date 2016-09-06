import QtQuick 2.2
import Sailfish.Silica 1.0
import eu.nagua 1.0

Page {
    id: page
    property variant taskData;
    property string description: taskData ? taskData.description : ""
    property string due: taskData ? taskData.due : ""

    TaskExecuter {
        id: executer
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Stuff")
                onClicked: console.log(taskData.description)
            }
        }

        Column {
            anchors.fill: parent
            spacing: Theme.paddingMedium

            SectionHeader {
                text: qsTr("Detail View")
            }
            TextField {
                label: qsTr("Description")
                text: description
            }
            TextField {
                label: qsTr("Due date")
                text: convert_date(due)
            }

        }
    }

    function convert_date(date) {
        // Ex: 20160901T110008Z
        if( date.length < 15)
            return Date.now()

        var year   = date.slice(00, 04);
        var month  = date.slice(04, 06);
        var day    = date.slice(06, 08);
        var hour   = date.slice(09, 11);
        var minute = date.slice(11, 13);
        var second = date.slice(13, 15);

        var utc_date = year + "-" + month + "-" + day + "T" + hour + ":" + minute + ":" + second + "Z";
        return utc_date;
    }
}

