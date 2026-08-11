import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Y3s.Tokens

Rectangle {
    id: root

    required property var app_ref
    required property bool is_current

    signal hovered()
    signal activated()

    width: ListView.view ? ListView.view.width : implicitWidth
    height: 48
    color: is_current ? Colors.md3.secondary_container : "transparent"
    radius: 6

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        IconImage {
            source: Quickshell.iconPath(root.app_ref.icon, "image-missing")
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            backer.sourceSize: Qt.size(56, 56)
        }

        Text {
            text: root.app_ref.name
            color: root.is_current ? Colors.md3.on_secondary_container : Colors.md3.on_surface
            font.family: "Google Sans"
            font.pixelSize: 14
            Layout.fillWidth: true
            elide: Text.ElideRight
            font.capitalization: Font.Capitalize
        }

    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered()
        onClicked: root.activated()
    }

}
