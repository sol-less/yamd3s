import QtQuick
import QtQuick.Layouts
import Y3s.Tokens
import qs.dashboard.system

Item {
    id: root

    implicitWidth: Metrics.panelSizes.system.width
    implicitHeight: Metrics.panelSizes.system.height

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        CircularIndicator {
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: contentCol.implicitHeight + 24
            radius: 16
            color: Colors.md3.surface_container_high

            ColumnLayout {
                id: contentCol

                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                InfoRow {
                    label: "Uptime"
                    value: InfoProcess.uptimeStr
                }

                InfoRow {
                    label: "Packages"
                    value: (InfoProcess.pacmanCount + InfoProcess.aurCount) + " pacman/AUR, " + InfoProcess.flatpakCount + " flatpak"
                }

            }

        }

    }

    component InfoRow: RowLayout {
        property string label: ""
        property string value: ""

        Layout.fillWidth: true

        Text {
            text: label
            font.family: "Google Sans"
            font.pixelSize: 13
            color: Colors.md3.on_surface_variant
            Layout.fillWidth: true
        }

        Text {
            text: value
            font.family: "Google Sans"
            font.pixelSize: 13
            font.weight: Font.Medium
            color: Colors.md3.on_surface
        }

    }

}
