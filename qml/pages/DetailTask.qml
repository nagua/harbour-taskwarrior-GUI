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
    property string wait: getJsonField("wait")

    TaskExecuter {
        id: executer
    }

    Column {
        width: parent.width
        spacing: Theme.paddingMedium

        DialogHeader {}

        PageHeader {
            title: taskData ? "Modify Task" : "Add Task"
        }

        TextArea {
            id: descriptionfield
            width: parent.width
            wrapMode: Text.Wrap
            focus: description === "" ? true : false
            label: qsTr("Description")
            text: description
            placeholderText: qsTr("Description")
            inputMethodHints: Qt.ImhNoAutoUppercase
        }
        TextField {
            id: projectfield
            width: parent.width
            label: qsTr("Project")
            text: project
            placeholderText: qsTr("Project")
            inputMethodHints: Qt.ImhNoAutoUppercase
        }
        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: delete_due_icon.height
            ValueButton {
                label: "Due date"
                value: formatDate(due)
                anchors.left: parent.left
                anchors.right: delete_due_icon.left
                onClicked: {
                    var dialog;
                    if (due !== "") {
                        var js_date = new Date(UT.convert_tdate_to_jsdate(due));
                        dialog = pageStack.push(Qt.resolvedUrl("DateView.qml"), {date_value: js_date})
                    } else {
                        dialog = pageStack.push(Qt.resolvedUrl("DateView.qml"))
                    }
                    dialog.accepted.connect(function() {
                        console.log(dialog.date_value);
                        due = UT.convert_jsdate_to_tdate(dialog.date_value);
                    });
                }
            }
            IconButton {
                id: delete_due_icon
                anchors.right: parent.right
                icon.source: "image://theme/icon-m-clear"
                onClicked: {
                    due = ""
                }
            }
        }
        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: delete_wait_icon.height
            ValueButton {
                label: "Wait until"
                value: formatDate(wait)
                anchors.left: parent.left
                anchors.right: delete_wait_icon.left
                onClicked: {
                    var dialog;
                    if (wait !== "") {
                        var js_date = new Date(UT.convert_tdate_to_jsdate(wait));
                        dialog = pageStack.push(Qt.resolvedUrl("DateView.qml"), {date_value: js_date})
                    } else {
                        dialog = pageStack.push(Qt.resolvedUrl("DateView.qml"))
                    }
                    dialog.accepted.connect(function() {
                        console.log(dialog.date_value);
                        wait = UT.convert_jsdate_to_tdate(dialog.date_value);
                    });
                }
            }
            IconButton {
                id: delete_wait_icon
                anchors.right: parent.right
                icon.source: "image://theme/icon-m-clear"
                onClicked: {
                    wait = ""
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
                json["project"] = projectfield.text !== "" ? projectfield.text : undefined
                json["due"] = due !== "" ? due : undefined
                json["wait"] = wait !== "" ? wait : undefined
                console.log(JSON.stringify(json));
                executer.executeTask(["import", "-"], JSON.stringify(json));
            }
            else {
                json = UT.copyItem(taskData.rawData);
                json["description"] = descriptionfield.text;
                json["project"] = projectfield.text !== "" ? projectfield.text : undefined
                json["due"] = due !== "" ? due : undefined
                json["wait"] = wait !== "" ? wait : undefined
                console.log(JSON.stringify(json));
                executer.executeTask(["import", "-"], JSON.stringify(json));
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
            var fo_date = Format.formatDate(js_date, Formatter.DateMedium);
            return fo_date;
        } else {
            return qsTr("no due date set")
        }
    }
}
