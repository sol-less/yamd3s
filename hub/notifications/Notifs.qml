import QtQuick
import QtQuick.Layouts
import Quickshell
import Y3s.Tokens

Item {
    id: root

    required property var notification

    width: ListView.view ? ListView.view.width : 0
    implicitHeight: column.height + 12
    clip: true

    Rectangle {
        z: -1
        anchors.fill: parent
        color: Colors.md3.primary
        radius: 6
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.notification.dismiss()
    }

    RowLayout {
        id: row

        anchors {
            fill: parent
            leftMargin: 8
        }

        Image {
            Layout.preferredHeight: 36
            Layout.preferredWidth: 36
            source: root.notification.image || root.notification.appIcon || ""
            fillMode: Image.PreserveAspectCrop
        }

        ColumnLayout {
            id: column

            spacing: 4
            z: 0

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

}
