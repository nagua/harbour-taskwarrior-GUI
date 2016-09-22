import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: item
    // Magic properties
    property bool down
    property bool highlighted
    property int __silica_menuitem
    property alias text: field.text
    property alias label: field.label
    property alias placeholderText: field.placeholderText

    // Needed properties to use as an menu item
    // Index is zero based
    property int  index
    property ContextMenu menu

    signal clicked


    width: parent.width
    height: Math.max(icon.height, field.height)

    TextField {
        id: field
        anchors.left: parent.left
        anchors.right: icon.left
        width: parent.width

        Keys.onReturnPressed: {
            menu.activated(index)
            menu.hide();
        }
    }
    IconButton {
        id: icon
        anchors.right: parent.right
        icon.source: "image://theme/icon-m-right"
        onClicked: {
            menu.activated(index)
            menu.hide();
        }
    }
}

