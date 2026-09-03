import M3Shapes
import QtQuick
import Quickshell
import Quickshell.Wayland
import Yamd3s

PanelWindow {
    required property var marginSize

    implicitHeight: root.height + 50
    implicitWidth:  root.width + 50
    color: "transparent"
    WlrLayershell.layer: WlrLayershell.Bottom
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        left: true
    }

    margins {
        top: marginSize + Math.round(ConfigManager.vanilla["layout.bar.height"] / 2)
        left: marginSize
    }

    SystemClock {
        id: sysClock
        precision: SystemClock.Seconds
    }

    Item {
        id: root

        implicitWidth: 150
        implicitHeight: 150
        clip: false
        anchors.centerIn: parent

        MaterialShape {
            id: clockFace
            anchors.centerIn: parent
            implicitSize: (parent.width || parent.height) - 6
            shape: MaterialShape.Cookie12Sided
            color: Theme.md3.surface_container_low

            readonly property real minutes: sysClock.minutes + (sysClock.seconds / 60)
            readonly property real hours: (sysClock.hours % 12) + (minutes / 60)

            MaterialShape {
                id: hourHand
                property real centerMargin: 24

                color: parent.color
                implicitSize: parent.implicitSize * 0.50
                shape: MaterialShape.Cookie12Sided
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                anchors.bottomMargin: centerMargin

                Text {
                    id: hourText
                    anchors.centerIn: parent
                    text: sysClock.hours
                    color: Theme.md3.primary
                    font.pixelSize: 28
                    font.weight: 1000
                    font.family: "Google Sans"

                    transform: Rotation {
                        origin.x: hourText.width / 2
                        origin.y: hourText.height / 2

                        angle: clockFace.hours * 6
                    }
                }

                transform: Rotation {
                    origin.x: hourHand.width / 2
                    origin.y: hourHand.height + hourHand.centerMargin
                    angle: -(clockFace.hours * 6)
                }
            }

            Rectangle {
                id: minuteHand
                implicitWidth: 10
                implicitHeight: parent.implicitHeight / 3
                radius: height / 2
                color: Theme.md3.primary
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                
                transform: Rotation {
                    origin.x: minuteHand.width / 2
                    origin.y: minuteHand.height
                    angle: clockFace.minutes * 6
                }
            }
        }

    }

}
