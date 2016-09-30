import QtQuick 2.2
import Sailfish.Silica 1.0

Item {
    width: parent.width
    height: childrenRect.height
    Rectangle {
        id: cut_line_fst
        anchors.left: parent.left
        width: parent.width/2
        height: 2
        color: "gray"
        opacity: 0.2
    }
    Rectangle {
        id: cut_line_snd
        anchors.left: cut_line_fst.right
        anchors.right: parent.right
        height: 2
        color: "gray"
        opacity: 0.2
    }

    OpacityRampEffect {
        sourceItem: cut_line_fst
        direction: OpacityRamp.RightToLeft
    }
    OpacityRampEffect {
        sourceItem: cut_line_snd
        direction: OpacityRamp.LeftToRight
    }
}

