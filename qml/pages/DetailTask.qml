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
        /*TextField {
            id: duefield
            width: parent.width
            label: qsTr("Due date")
            text: Format.formatDate(new Date(UT.convert_tdate_to_jsdate(due)),Formatter.DateMedium)
            placeholderText: qsTr("Due date")
        }*/
        ValueButton {
            label: "Due date"
            value: formatDate(due)
            onClicked: {
                if (due !== "") {
                    var js_date = new Date(UT.convert_tdate_to_jsdate(due));
                    pageStack.push(Qt.resolvedUrl("DateView.qml"), {date_value: js_date})
                } else {
                    pageStack.push(Qt.resolvedUrl("DateView.qml"))
                }
            }
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

    function formatDate(str_date) {
        if (str_date !== "") {
            var js_date = new Date(UT.convert_tdate_to_jsdate(str_date));
            var fo_date = Format.formatDate(js_date, Formatter.TimepointRelativeCurrentDay);
            return fo_date;
        } else {
            return qsTr("no due date set")
        }
    }
}
