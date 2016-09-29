import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.taskwarrior 1.0
import "../lib/utils.js" as UT

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
            focus: description === "" ? true : false
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
            text: UT.convert_tdate_to_jsdate(due)
            placeholderText: qsTr("Due date")
        }
    }

    onDone: {
        if ( result == DialogResult.Accepted ) {
            var json = {};
            var out = "";
            if (typeof taskData == "undefined") {
                json["description"] = descriptionfield.text;
                json["project"] = projectfield.text
                //json["due"] = duefield.text
                out = executer.executeTask(["import", "-"], JSON.stringify(json));
                console.log(out);
            }
            else {
                json = UT.copyItem(taskData.rawData);
                json["description"] = descriptionfield.text;
                json["project"] = projectfield.text
                console.log(JSON.stringify(json));
                out = executer.executeTask(["import", "-"], JSON.stringify(json));
                console.log(out);
            }
        }
    }

    function getJsonField(item) {
        var td = taskData;
        if(taskData && taskData.rawData.hasOwnProperty(item) ) {
            return taskData.rawData[item];
        }
        return "";
    }
}
