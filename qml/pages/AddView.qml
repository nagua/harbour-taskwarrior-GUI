import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property string name
    property string query
    property string section

    Column {
        width: parent.width

        DialogHeader {}

        TextField {
            id: viewname
            width: parent.width
            text: name
            label: qsTr("View Name")
            placeholderText: qsTr("Enter the name of the view here")
        }
        TextField {
            id: queryfield
            width: parent.width
            text: query
            label: qsTr("Query")
            placeholderText: qsTr("Enter new query here")
        }
        TextField {
            id: sectionfield
            width: parent.width
            text: section
            label: qsTr("Section")
            placeholderText: qsTr("Enter the section of the view")
        }
    }

    onDone: {
        if( result == DialogResult.Accepted ) {
            name = viewname.text
            query = queryfield.text
            section = sectionfield.text
        }
    }
}

