import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Y3s.Globals
import Y3s.Lib
import Y3s.Tokens
import qs.dashboard.music

Item {
    id: root

    implicitWidth: Metrics.panelSizes.music.width
    implicitHeight: Metrics.panelSizes.music.height

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
            // 1. Enable slider whenever a player is active (bypasses Spotify's false canSeek flag)
            enabled: Variable.player !== null && Variable.playback.length > 0
            trackColor: Colors.roleColor("music_progress")
            // 2. Declarative binding: tracks position when idle, holds drag value when pressed
            value: pressed ? value : Variable.playback.position
            // 3. Send position to MPRIS on slider release
            onPressedChanged: {
                if (!pressed && Variable.player)
                    Variable.player.position = value;

            }
        }

        TransportControls {
            Layout.alignment: Qt.AlignHCenter
        }

    }

}
