import Yamd3s.Globals
import M3Shapes
import QtQuick
import QtQuick.Controls.Basic


Button {
    id: button

    property real size: 50
    property var textInside: "\ue872"

    text: "Placeholder text"
    font.family: "Google Sans"
    font.pixelSize: 18
    implicitHeight: size
    implicitWidth: size

    background: Rectangle {
        implicitWidth: button.size
        implicitHeight: button.size
        radius: 6
        color: Colors.roleColor("actionsButton")

        MaterialShape {
            shape: MaterialShape.Cookie4Sided
            anchors.centerIn: parent
            implicitSize: button.size / 1.5
            color: Colors.roleColor("actionsButton", "container")

            Text {
                anchors.centerIn: parent
                text: button.textInside
                font.family: "Material Symbols Rounded"
                font.pixelSize: 14
                color: Colors.roleColor("actionsButton", "onContainer")
            }

        }

    }

    contentItem: Text {
        leftPadding: button.background.implicitWidth + button.spacing
        verticalAlignment: Text.AlignVCenter
        text: button.text
        font.family: button.font.family
        font.pixelSize: button.font.pixelSize
        color: Colors.roleColor("actonsButton")
    }

}
