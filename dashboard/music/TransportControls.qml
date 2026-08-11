import M3Shapes
import QtQuick
import QtQuick.Layouts
import Y3s.Lib
import Y3s.Tokens

RowLayout {
    id: root

    spacing: 24

    Repeater {
        model: [{
            "action": () => {
                return Variable.player.previous();
            },
            "icon": "\ue045",
            "shape": MaterialShape.Square,
            "enabled": Variable.capabilities.canGoPrevious
        }, {
            "action": () => {
                Variable.player.isPlaying = !Variable.player.isPlaying;
            },
            "icon": Variable.playback.isPlaying ? "\ue034" : "\ue037",
            "shape": Variable.playback.isPlaying ? MaterialShape.Square : MaterialShape.Circle,
            "enabled": Variable.capabilities.canTogglePlaying
        }, {
            "action": () => {
                return Variable.player.next();
            },
            "icon": "\ue044",
            "shape": MaterialShape.Square,
            "enabled": Variable.capabilities.canGoNext
        }]

        delegate: MaterialShape {
            id: btnDelegate

            required property var modelData
            required property var index

            width: 40
            height: 40
            shape: index === 1 ? (mouseHandler.containsMouse ? MaterialShape.Square : MaterialShape.Cookie4Sided) : (mouseHandler.containsMouse ? MaterialShape.Cookie6Sided : MaterialShape.Circle)
            color: Colors.md3.primary
            animationDuration: 300
            animationEasing.type: Easing.OutBack

            Text {
                anchors.centerIn: parent
                text: btnDelegate.modelData.icon
                font.family: "Material Symbols Rounded"
                font.pixelSize: 20
                color: Colors.md3.on_primary
            }

            MouseArea {
                id: mouseHandler

                anchors.fill: parent
                hoverEnabled: true
                enabled: btnDelegate.modelData.enabled
                onClicked: btnDelegate.modelData.action()
            }

        }

    }

}
