import M3Shapes
import QtQuick
import QtQuick.Layouts
import Yamd3s.Globals
import Yamd3s.Core

Rectangle {
    id: root

    readonly property var allTabs: ConfigManager.components.hub
    readonly property var tabs: States.allTabs ?? []

    function switcherTabsIcon(i) {
        return root.tabs?.[i]?.icon ?? "";
    }

    function switcherTabsLabel(i) {
        return root.tabs?.[i]?.name ?? "";
    }

    Layout.fillWidth: true
    Layout.preferredHeight: 52
    radius: height / 2
    color: Theme.md3.surface_container_high
    focus: true

    Shortcut {
        sequence: "Shift+Tab"
        onActivated: {
            let prevIndex = States.activePanel - 1;
            if (prevIndex < 0)
                prevIndex = root.tabs.length - 1;

            States.setPanel(prevIndex);
        }
    }

    Shortcut {
        sequence: "Tab"
        onActivated: {
            let nextIndex = States.activePanel + 1;
            if (nextIndex >= root.tabs.length)
                nextIndex = 0;

            States.setPanel(nextIndex);
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 3

        Repeater {
            model: tabs.length

            delegate: Rectangle {
                id: tab_slot

                required property int index
                readonly property bool isActive: States.activePanel === index
                property real firstIndex: (index === 0 || isActive) ? height / 2 : 6
                property real lastIndex: (index === root.tabs.length - 1 || isActive) ? height / 2 : 6

                Layout.fillWidth: true
                Layout.fillHeight: true
                bottomLeftRadius: firstIndex
                topLeftRadius: firstIndex
                bottomRightRadius: lastIndex
                topRightRadius: lastIndex
                color: isActive ? Theme.roleColor("switcher") : "transparent"

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 4

                    Item {
                        Layout.preferredWidth: iconText.implicitWidth
                        Layout.preferredHeight: iconText.implicitHeight

                        Text {
                            id: iconText

                            y: 2
                            text: root.switcherTabsIcon(tab_slot.index)
                            font.family: "Material Symbols Rounded"
                            font.pixelSize: 16
                            color: tab_slot.isActive ? Theme.roleColor("switcher", "on") : Theme.md3.on_surface_variant

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                        }
                    }

                    Text {
                        text: root.switcherTabsLabel(tab_slot.index)
                        font.family: "Google Sans"
                        font.weight: tab_slot.isActive ? 500 : 400
                        font.pixelSize: 12
                        color: tab_slot.isActive ? Theme.roleColor("switcher", "on") : Theme.md3.on_surface_variant

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }

                        Behavior on font.pixelSize {
                            NumberAnimation {
                                duration: 250
                                easing.type: Easing.OutQuint
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: States.setPanel(tab_slot.index)
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                Behavior on topLeftRadius {
                    SpringAnimation {
                        spring: 3.2
                        damping: 0.18
                        mass: 1
                        epsilon: 0.25
                    }
                }

                Behavior on topRightRadius {
                    SpringAnimation {
                        spring: 3.2
                        damping: 0.18
                        mass: 1
                        epsilon: 0.25
                    }
                }

                Behavior on bottomLeftRadius {
                    SpringAnimation {
                        spring: 3.2
                        damping: 0.18
                        mass: 1
                        epsilon: 0.25
                    }
                }

                Behavior on bottomRightRadius {
                    SpringAnimation {
                        spring: 3.2
                        damping: 0.18
                        mass: 1
                        epsilon: 0.25
                    }
                }
            }
        }

        MaterialShape {
            Layout.fillHeight: true
            Layout.preferredWidth: 50
            shape: hoverHandler.hovered ? MaterialShape.Cookie7Sided : MaterialShape.Cookie4Sided
            color: hoverHandler.hovered ? Theme.roleColor("switcher") : Theme.md3.surface_container_highest

            Text {
                anchors.centerIn: parent
                font.family: "Material Symbols Rounded"
                color: hoverHandler.hovered ? Theme.roleColor("switcher", "on") : Theme.md3.on_surface_variant
                text: "\ue8b8"

                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }
                }
            }

            HoverHandler {
                id: hoverHandler
            }

            MouseArea {
                anchors.fill: parent
                onClicked: States.toggleSettings()
            }

            Behavior on color {
                ColorAnimation {
                    duration: 250
                }
            }
        }
    }
}
