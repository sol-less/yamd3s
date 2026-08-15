import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Y3s.Lib
import Y3s.Tokens
import qs.bar.components

PanelWindow {
    id: root

    height: Metrics.bar_height
    color: "transparent"
    WlrLayershell.exclusiveZone: Metrics.bar_height

    anchors {
        top: true
        left: true
        right: true
    }

    Rectangle {
        id: barContainer

        anchors.centerIn: parent
        height: Metrics.bar_height
        width: rowContainer.implicitWidth + 12
        color: Colors.md3.surface_container_low
        bottomLeftRadius: 12
        bottomRightRadius: 12

        Corners {
            r: 12
            corner: 4
            anchors.top: parent.top
            anchors.left: parent.right
            fillColor: parent.color
        }

        Corners {
            r: 12
            corner: 1
            anchors.top: parent.top
            anchors.right: parent.left
            fillColor: parent.color
        }

        RowLayout {
            id: rowContainer

            anchors.centerIn: parent
            spacing: 12

            Workspaces {
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillHeight: true
                Layout.preferredWidth: clock.width

                Clock {
                    id: clock

                    height: barContainer.height - 12
                }

            }

            PowerMenu {
                Layout.alignment: Qt.AlignVCenter
            }

        }

    }

}
