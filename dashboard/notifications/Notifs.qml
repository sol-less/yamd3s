import QtQuick
import QtQuick.Layouts
import Quickshell
import Y3s.Tokens

Item {
    id: root

    required property var notification

    Layout.fillWidth: true
    height: column.height + 12
    clip: true

    Rectangle {
        z: -1
        anchors.fill: parent
        color: Colors.md3.primary
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.notification.dismiss()
    }

    ColumnLayout {
        id: column

        spacing: 4
        z: 0

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: 8
            rightMargin: 8
        }

        Repeater {
            model: [{
                "action": root.notification.summary
            }, {
                "action": root.notification.body
            }]

            delegate: Text {
                required property var modelData
                required property var index

                Layout.fillWidth: true
                text: modelData.action ?? ""
                font.pixelSize: index === 0 ? 14 : 12
                font.family: "Google Sans"
                elide: Text.ElideRight
            }

        }

    }

}
