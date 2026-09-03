import QtQuick
import QtQuick.Layouts
import Yamd3s
import qs.qml.shell.hub.system

Item {
    id: root

    implicitWidth:  ConfigManager.vanilla["panels.system.width"]
    implicitHeight: ConfigManager.vanilla["panels.system.height"]

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        CircularIndicator {
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: contentCol.implicitHeight + 24
            radius: 16
            color: Theme.md3.surface_container_high

            ColumnLayout {
                id: contentCol

                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                InfoRow {
                    label: "Uptime"
                    value: SystemMonitor.uptime
                }

                InfoRow {
                    label: "Packages"
                    value: (SystemMonitor.packages) + " Total installed"
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
            color: Theme.md3.on_surface_variant
            Layout.fillWidth: true
        }

        Text {
            text: value
            font.family: "Google Sans"
            font.pixelSize: 13
            font.weight: Font.Medium
            color: Theme.md3.on_surface
        }

    }

}
