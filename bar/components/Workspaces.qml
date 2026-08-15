import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import M3Shapes
import Y3s.Tokens

Item {
    id: root
    implicitHeight: row.implicitHeight
    implicitWidth: row.implicitWidth
    readonly property int activeWorkspaceId: Hyprland.focusedWorkspace?.id ?? 0
    property bool recentlyChanged: false

    onActiveWorkspaceIdChanged: {
        recentlyChanged = true;
        wsTimer.restart();
    }

    Timer {
        id: wsTimer
        interval: 1000
        onTriggered: root.recentlyChanged = false
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        height: parent.height
        spacing: 3

        Repeater {
            model: 5
            delegate: Item {
                id: dot_slot
                required property int index
                property bool focused: Hyprland.focusedWorkspace?.id === index + 1
                height: 28
                width: 28

                MaterialShape {
                    anchors.fill: parent
                    shape: dot_slot.focused ? MaterialShape.Cookie7Sided : MaterialShape.Circle
                    color: dot_slot.focused ? Colors.roleColor("workspaces") : Colors.md3.on_surface_variant
                    opacity: dot_slot.focused ? 1.0 : 0.2
                    animationDuration: 350
                    animationEasing.type: Easing.OutBack
                    rotation: mouseHandler.containsMouse ? -20 : 0
                    scale: mouseHandler.containsMouse ? 1.1 : 1

                    Behavior on rotation {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutQuad
                        }
                    }
                    Behavior on scale {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutQuad
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 250
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutQuad
                        }
                    }
                }

                MouseArea {
                    id: mouseHandler
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({workspace = ", (dot_slot.index + 1).toString(), "})"])
                }
            }
        }
    }
}
