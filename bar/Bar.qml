import QtQuick
import Quickshell
import Quickshell.Wayland
import Y3s.Lib
import Y3s.Tokens
import qs.bar.components

PanelWindow {
    implicitHeight: Metrics.bar_height + 24
    color: "transparent"
    WlrLayershell.exclusiveZone: Metrics.bar_height

    anchors {
        top: true
        left: true
        right: true
    }

    Rectangle {
        id: barContainer

        implicitHeight: Metrics.bar_height
        implicitWidth: parent.width
        z: -99
        color: Colors.md3.surface_container

        Corners {
            r: 24
            anchors.top: parent.bottom
            anchors.left: parent.left
            fillColor: barContainer.color
        }

        Corners {
            corner: 1
            r: 24
            anchors.top: parent.bottom
            anchors.right: parent.right
            fillColor: barContainer.color
        }

    }

    Workspaces {
        anchors.left: barContainer.left
        anchors.verticalCenter: barContainer.verticalCenter
        anchors.margins: 6
    }

    Clock {
        anchors.centerIn: barContainer
        height: barContainer.height - 12
    }

    PowerMenu {
        anchors.right: barContainer.right
        anchors.verticalCenter: barContainer.verticalCenter
        anchors.margins: 6
    }

}
