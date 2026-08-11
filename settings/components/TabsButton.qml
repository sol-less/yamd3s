import QtQuick
import QtQuick.Layouts
import Y3s.Globals
import Y3s.Tokens

Rectangle {
    id: btn

    required property var modelData
    required property int index

    signal clicked()

    color: States.currentSettingTab === index ? Colors.md3.primary : "transparent"
    radius: 99

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10

        Repeater {
            model: 2

            delegate: Text {
                property var firstIndex: index === 0

                horizontalAlignment: Text.AlignLeft
                text: firstIndex ? btn.modelData.icon : btn.modelData.label
                font.family: firstIndex ? "Material Icons Rounded" : "Google Sans"
                color: Colors.md3.surface_container_highest
            }

        }

        Item {
            Layout.fillWidth: true
        }

    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: parent.clicked()
    }

}
