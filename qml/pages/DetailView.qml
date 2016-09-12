import QtQuick 2.2
import Sailfish.Silica 1.0
import eu.nagua 1.0

Dialog {
    id: page
    property variant taskData;
    property string description: getJsonField("description")
    property string project: getJsonField("project")
    property string due: getJsonField("due")

    TaskExecuter {
        id: executer
    }

    Column {
        width: parent.width
        spacing: Theme.paddingMedium

        DialogHeader {}

        SectionHeader {
            text: qsTr("Detail View")
        }
        TextArea {
            width: parent.width
            wrapMode: Text.Wrap
            label: qsTr("Description")
            text: description
        }
        TextField {
            width: parent.width
            label: qsTr("Project")
            text: project
            placeholderText: qsTr("Project")
        }
        TextField {
            width: parent.width
            label: qsTr("Due date")
            text: convert_tdate_to_jsdate(due)
        }
    }

    function convert_tdate_to_jsdate(date) {
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

    function getJsonField(item) {
        if(taskData && taskData.hasOwnProperty(item) ) {
            return taskData[item];
        }
        return "";
    }
}

