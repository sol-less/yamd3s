import M3Shapes
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Yamd3s.Core

Item {
    height: 50

    RowLayout {
        id: root

        anchors.centerIn: parent
        spacing: 4
        z: 0

        Repeater {
            model: [{
                "id": "prev",
                "action": () => {
                    return Variable.player.previous();
                },
                "icon": "\ue045"
            }, {
                "id": "playpause",
                "action": () => {
                    return Variable.player.isPlaying = !Variable.player.isPlaying;
                },
                "icon": ""
            }, {
                "id": "next",
                "action": () => {
                    return Variable.player.next();
                },
                "icon": "\ue044"
            }]

            delegate: Button {
                id: btnDelegate

                required property var modelData
                required property var index
                property real dynamicScale: down ? 0.95 : (hoverHandler.hovered ? 1.05 : 1)

                onClicked: modelData.action()
                hoverEnabled: false
                implicitWidth: (btnDelegate.index === 1 ? 100 : 70) * dynamicScale
                implicitHeight: 40 * dynamicScale
                enabled: {
                    if (modelData.id === "prev")
                        return Variable.capabilities.canGoPrevious;

                    if (modelData.id === "playpause")
                        return Variable.capabilities.canTogglePlaying;

                    if (modelData.id === "next")
                        return Variable.capabilities.canGoNext;

                    return false;
                }

                HoverHandler {
                    id: hoverHandler
                }

                Behavior on dynamicScale {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutBack
                        easing.overshoot: 2
                    }

                }

                background: Rectangle {
                    id: bg

                    anchors.centerIn: parent
                    color: Theme.roleColor("musicPlayButton")
                    bottomLeftRadius: btnDelegate.index === 0 ? height / 2 : 6
                    topLeftRadius: btnDelegate.index === 0 ? height / 2 : 6
                    bottomRightRadius: btnDelegate.index === 2 ? height / 2 : 6
                    topRightRadius: btnDelegate.index === 2 ? height / 2 : 6
                    scale: btnDelegate.down ? 0.95 : (hoverHandler.hovered ? 1.05 : 1)

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 150
                        }

                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutBack
                            easing.overshoot: 2
                        }

                    }

                }

                contentItem: Text {
                    text: {
                        if (btnDelegate.modelData.id === "playpause")
                            return Variable.playback.isPlaying ? "\ue034" : "\ue037";

                        return btnDelegate.modelData.icon;
                    }
                    font.family: "Material Symbols Rounded"
                    font.pixelSize: btnDelegate.index === 1 ? 24 : 20
                    color: Theme.roleColor("musicPlayButton", "on")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    scale: btnDelegate.down ? 0.8 : (hoverHandler.hovered ? 1.15 : 1)

                    Behavior on scale {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutBack
                        }

                    }

                }

            }

        }

    }

}
