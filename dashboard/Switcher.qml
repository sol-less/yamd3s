import M3Shapes
import QtQuick
import QtQuick.Layouts
import Y3s.Globals
import Y3s.Tokens

Rectangle {
    readonly property var allTabs: Config.allTabs
    readonly property var tabs: States.visibleTabs

    function switcher_tabs_icon(i) {
        return tabs[i].icon;
    }

    function switcher_tabs_label(i) {
        return tabs[i].label;
    }

    Layout.fillWidth: true
    Layout.preferredHeight: 52
    radius: height / 2
    color: Colors.md3.surface_container_high
    focus: true

    Shortcut {
        sequence: "Shift+Tab"
        onActivated: {
            let prevIndex = States.activePanel - 1;
            if (prevIndex < 0)
                prevIndex = tabs.length - 1;

            States.setPanel(prevIndex);
        }
    }

    Shortcut {
        sequence: "Tab"
        onActivated: {
            let nextIndex = States.activePanel + 1;
            if (nextIndex >= tabs.length)
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
                property real lastIndex: (index === tabs.length - 1 || isActive) ? height / 2 : 6

                Layout.fillWidth: true
                Layout.fillHeight: true
                bottomLeftRadius: firstIndex
                topLeftRadius: firstIndex
                bottomRightRadius: lastIndex
                topRightRadius: lastIndex
                color: isActive ? Colors.roleColor("switcher", "container") : "transparent"

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 4

                    Item {
                        Layout.preferredWidth: iconText.implicitWidth
                        Layout.preferredHeight: iconText.implicitHeight

                        Text {
                            id: iconText

                            y: 2
                            text: switcher_tabs_icon(tab_slot.index)
                            font.family: "Material Symbols Rounded"
                            font.pixelSize: 16
                            color: tab_slot.isActive ? Colors.roleColor("switcher", "on_container") : Colors.md3.on_surface_variant

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }

                            }

                        }

                    }

                    Text {
                        text: switcher_tabs_label(tab_slot.index)
                        font.family: "Google Sans"
                        font.weight: tab_slot.isActive ? 500 : 400
                        font.pixelSize: 12
                        color: tab_slot.isActive ? Colors.roleColor("switcher", "on_container") : Colors.md3.on_surface_variant

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
            color: hoverHandler.hovered ? Colors.roleColor("switcher") : Colors.md3.surface_container_highest

            Text {
                anchors.centerIn: parent
                font.family: "Material Symbols Rounded"
                color: hoverHandler.hovered ? Colors.roleColor("switcher", "on") : Colors.md3.on_surface_variant
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
