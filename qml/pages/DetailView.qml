import QtQuick 2.2
import Sailfish.Silica 1.0
import eu.nagua 1.0

Dialog {
    id: page
    property var taskData;
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
            id: descriptionfield
            width: parent.width
            wrapMode: Text.Wrap
            label: qsTr("Description")
            text: description
            placeholderText: qsTr("Description")
        }
        TextField {
            id: projectfield
            width: parent.width
            label: qsTr("Project")
            text: project
            placeholderText: qsTr("Project")
        }
        TextField {
            id: duefield
            width: parent.width
            label: qsTr("Due date")
            text: convert_tdate_to_jsdate(due)
            placeholderText: qsTr("Due date")
        }
    }

    onDone: {
        if ( result == DialogResult.Accepted ) {
            if (typeof taskData == "undefined") {
                var json = {};
                json["description"] = descriptionfield.text;
                json["project"] = projectfield.text
                //json["due"] = duefield.text
                var out = executer.executeTask(["import", "-"], JSON.stringify(json));
                console.log(out);
            }
        }
    }

    function convert_tdate_to_jsdate(date) {
        // Ex: 20160901T110008Z
        if( date.length < 15)
            return ""

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
        var td = taskData;
        if(taskData && taskData.hasOwnProperty(item) ) {
            return taskData[item];
        }
        return "";
    }
}

