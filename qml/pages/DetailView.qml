import QtQuick 2.2
import Sailfish.Silica 1.0
import eu.nagua 1.0

Page {
    id: page
    //property variant taskData;
    //property string description: taskData ? taskData.description : ""

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
            InfoLabel {
                text: qsTr("Stuff")
            }
        }
    }
}

