import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Yamd3s

Rectangle {
    id: root

    required property var app_ref
    required property bool is_current

    signal hovered()
    signal activated()

    readonly property string safeIcon: {
        const icon = root.app_ref?.icon ?? "";
        
        if (!icon || icon === "undefined" || icon.includes("/path/to/")) {
            return "";
        }
        
        if (icon.startsWith("/")) {
            return icon; 
        }

        return icon;
    }

    implicitWidth: ListView.view ? ListView.view.width : implicitWidth
    implicitHeight: 48
    color: is_current ? Theme.md3.secondary : "transparent"
    radius: 6

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        IconImage {
            source: root.safeIcon !== "" ? Quickshell.iconPath(root.safeIcon, "") : ""
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            backer.sourceSize: Qt.size(56, 56)
        }

        Text {
            text: root.app_ref?.name ?? ""
            color: root.is_current ? Theme.md3.on_secondary : Theme.md3.on_surface
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