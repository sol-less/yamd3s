import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Yamd3s

Rectangle {
    id: root
    property real cornerRadius: height / 2
    property real moduleIndex: 0

    readonly property var sinkAudio: Pipewire.defaultAudioSink?.audio
    property real currentVolume: sinkAudio?.volume ?? 0.0
    readonly property bool isMuted: sinkAudio?.muted ?? false

    readonly property real clockWidth: (mouseHandler.containsMouse ? dateText.width : timeText.width) + 24
    readonly property real sliderWidth: 220

    signal volumeChange()
    signal launcherOpen()

    function setVolumeIcon() {
        if (root.isMuted) {
            return "\ue04f";
        } else if (root.currentVolume > 0.6) {
            return "\ue050";
        } else if (root.currentVolume > 0.2) {
            return "\ue04d";
        } else if (root.currentVolume > 0) {
            return "\ue04e";
        } else {
            return "\ue04f";
        }
    }

    width: moduleIndex === 1 ? sliderWidth : clockWidth
    height: parent.height
    radius: cornerRadius
    color: moduleIndex === 1 ? "transparent" : Theme.roleColor("clock")
    clip: true

    PwObjectTracker {
        id: audioTracker
        objects: Pipewire.defaultAudioSink ?? []
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }

    SystemClock {
        id: sysClock
        precision: SystemClock.Seconds
    }

    Timer {
        id: volTimer
        interval: ConfigManager.vanilla["behavior.bar.autoHideDelay"]
        repeat: false
        onTriggered: {
            root.moduleIndex = 0;
        }
    }

    onCurrentVolumeChanged: {
        root.moduleIndex = 1;
        volTimer.restart();
    }

    onIsMutedChanged: {
        root.moduleIndex = 1;
        volTimer.restart();
    }

    SequentialAnimation {
        id: open_punch
        NumberAnimation {
            target: root
            property: "cornerRadius"
            to: 6
            duration: 180
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: root
            property: "cornerRadius"
            to: root.height / 2
            duration: 380
            easing.type: Easing.OutBack
            easing.overshoot: 3.5
        }
    }

    Item {
        anchors.fill: parent
        opacity: root.moduleIndex === 0 ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }

        Text {
            id: timeText
            anchors.centerIn: parent
            text: Qt.formatDateTime(sysClock.date, "hh:mm")
            font.family: "Google Sans"
            font.weight: 500
            font.pixelSize: 18
            color: Theme.roleColor("clock", "on")
            opacity: mouseHandler.containsMouse ? 0 : 1
            y: (parent.height - height) / 2 + (mouseHandler.containsMouse ? -8 : 0)

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
                }
            }

            Behavior on y {
                NumberAnimation {
                    duration: 250
                    easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
                }
            }
        }

        Text {
            id: dateText
            anchors.centerIn: parent
            text: Qt.formatDateTime(sysClock.date, "dd ddd, MMM")
            font.family: "Google Sans"
            font.weight: 500
            font.pixelSize: 18
            color: Theme.roleColor("clock", "on")
            opacity: mouseHandler.containsMouse ? 1 : 0
            y: (parent.height - height) / 2 + (mouseHandler.containsMouse ? 0 : 8)

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
                }
            }

            Behavior on y {
                NumberAnimation {
                    duration: 250
                    easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
                }
            }
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 8
        opacity: root.moduleIndex === 1 ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }

        RowLayout {
            anchors.fill: parent

            Text {
                Layout.fillHeight: true
                verticalAlignment: Text.AlignVCenter
                text: root.setVolumeIcon()
                font.family: "Material Symbols Rounded"
                font.pixelSize: 24
                color: !root.isMuted ? Theme.md3.secondary : Qt.alpha(Theme.md3.on_surface, 0.38)
            }

            ControlSlider {
                Layout.fillHeight: true
                Layout.fillWidth: true
                value: root.currentVolume * 100
                trackHeight: parent.height + 2
                thumbSize: parent.height + 8
                gapSize: 2
                enabled: !root.isMuted
                trackRadii: ConfigManager.vanilla["layout.radii.compact"]
                onPressedChanged: {
                    if (!pressed) {
                        root.currentVolume = value;
                    }
                }
                onValueChanged: root.volumeChange()
            }
        }
    }

    Item {
        anchors.fill: parent
        opacity: root.moduleIndex === 2 ? 1 : 0
        visible: opacity > 0
    }

    MouseArea {
        id: mouseHandler
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.RightButton
        onContainsMouseChanged: {
            if (containsMouse && root.moduleIndex === 0) {
                open_punch.start();
            } else {
                open_punch.stop();
                root.cornerRadius = root.height / 2;
            }
        }
        onClicked: {
            root.launcherOpen()
        }

    }

    Behavior on width {
        SpringAnimation {
            spring: 3.2
            damping: 0.18
            mass: 1
            epsilon: 0.25
        }
    }
}
