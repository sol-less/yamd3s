import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Yamd3s.Globals
import Yamd3s.Core
import Yamd3s.UI

import qs.qml.hub.music

Item {
    id: root

    implicitWidth: ConfigManager.panels.music.width
    implicitHeight: ConfigManager.panels.music.height

    Image {
        id: backgroundImage

        anchors.fill: parent
        source: Variable.track.artUrl
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        visible: false
    }

    MultiEffect {
        anchors.fill: backgroundImage
        source: backgroundImage
        blurEnabled: true
        blur: 0.6
        blurMax: 32
        opacity: 0.3
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        RowLayout {
            spacing: 14

            CoverArt {
            }

            Metadata {
                Layout.fillWidth: true
            }

        }

        Slider {
            id: progressSlider

            Layout.fillWidth: true
            from: 0
            to: Variable.playback.length > 0 ? Variable.playback.length : 1
            enabled: Variable.player !== null && Variable.playback.length > 0
            trackColor: Theme.roleColor("musicProgress")
            value: pressed ? value : Variable.playback.position
            onPressedChanged: {
                if (!pressed && Variable.player)
                    Variable.player.position = value;

            }
            trackRadii: 6
        }

        TransportControls {
            Layout.alignment: Qt.AlignHCenter
        }

    }

}
