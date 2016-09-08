import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property string name
    property string query

    Column {
        width: parent.width

        DialogHeader {}

        TextField {
            id: viewname
            width: parent.width
            label: qsTr("View Name")
            placeholderText: qsTr("Enter the name of the view here")
        }
        TextField {
            id: queryfield
            width: parent.width
            label: qsTr("Query")
            placeholderText: qsTr("Enter new query here")
        }
    }

    onDone: {
        if( result == DialogResult.Accepted ) {
            name = viewname.text
            query = queryfield.text
        }
    }
}

