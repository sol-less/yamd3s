import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Y3s.Globals
import Y3s.Lib
import Y3s.Tokens
import qs.bar.components

PanelWindow {
    id: root

    property bool modulesActive: hoverHandler.hovered || clock.moduleIndex === 1 || workspaces.recentlyChanged
    property bool isHovered: Config.others.autoHideBar ? (modulesActive || timerHandler.running) : true

    onModulesActiveChanged: {
        if (Config.others.autoHideBar) {
            if (!modulesActive)
                timerHandler.restart();
            else
                timerHandler.stop();
        }
    }
    height: Metrics.barHeight
    color: "transparent"
    WlrLayershell.exclusiveZone: Config.others.autoHideBar ? Metrics.barHeight - 24 : Metrics.barHeight

    anchors {
        top: true
        left: true
        right: true
    }

    Timer {
        id: timerHandler

        running: false
        interval: 500
    }

    Rectangle {
        id: barContainer

        anchors.horizontalCenter: parent.horizontalCenter
        height: Metrics.barHeight
        width: rowContainer.implicitWidth + 12
        color: Colors.md3.surface_container_low
        bottomLeftRadius: root.isHovered ? 12 : 10
        bottomRightRadius: root.isHovered ? 12 : 10
        y: root.isHovered ? 0 : -height + 16

        RowLayout {
            id: rowContainer

            anchors.centerIn: parent
            spacing: 12

            Workspaces {
                id: workspaces

                Layout.alignment: Qt.AlignVCenter
                opacity: root.isHovered ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutQuad
                    }

                }

            }

            Item {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillHeight: true
                Layout.preferredWidth: clock.width
                opacity: root.isHovered ? 1 : 0

                Clock {
                    id: clock

                    height: barContainer.height - 12
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutQuad
                    }

                }

            }

            PowerMenu {
                Layout.alignment: Qt.AlignVCenter
                opacity: root.isHovered ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutQuad
                    }

                }

            }

        }

        HoverHandler {
            id: hoverHandler
        }

        Behavior on y {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutQuad
            }

        }

    }

    Corners {
        r: 12
        corner: 0
        anchors.top: parent.top
        anchors.left: barContainer.right
        fillColor: barContainer.color
    }

    Corners {
        r: 12
        corner: 1
        anchors.top: parent.top
        anchors.right: barContainer.left
        fillColor: barContainer.color
    }

}
