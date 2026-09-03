import QtQuick
import QtQuick.Controls.Basic
import M3Shapes
import Yamd3s

Slider {
    id: control

    property int trackHeight: 28
    property int thumbSize: 20
    property int thumbRadius: 4
    property int gapSize: 6
    property int stopIndicatorSize: 4
    property int trackRadii: 0
    property var trackColor: Theme.md3.secondary

    value: 0.5
    from: 0
    to: 100
    width: 200
    height: 48

    readonly property real thumbCenterPos: leftPadding + visualPosition * availableWidth

    background: Item {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - control.trackHeight / 2
        width: control.availableWidth
        height: control.trackHeight

        Rectangle {
            id: activeTrack

            x: 0
            y: 0
            height: trackHeight
            width: Math.max(0, (control.visualPosition * parent.width) - (control.thumbSize / 2) - control.gapSize)
            anchors.verticalCenter: parent.verticalCenter
            bottomLeftRadius: control.trackRadii
            topLeftRadius: control.trackRadii
            color: control.enabled ? control.trackColor : Qt.alpha(Theme.md3.on_surface, 0.38)
        }

        Rectangle {
            id: inactiveTrack

            x: Math.min(parent.width, (control.visualPosition * parent.width) + (control.thumbSize / 2) + control.gapSize)
            y: 0
            height: trackHeight
            width: Math.max(0, parent.width - x)
            anchors.verticalCenter: parent.verticalCenter
            bottomRightRadius: control.trackRadii
            topRightRadius: control.trackRadii
            color: control.enabled ? Theme.md3.surface_variant : Qt.alpha(Theme.md3.on_surface, 0.12)

            Rectangle {
                implicitWidth: control.stopIndicatorSize
                implicitHeight: control.stopIndicatorSize
                radius: width / 2
                anchors.right: parent.right
                anchors.rightMargin: (parent.height - width) / 2
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.md3.surface
                visible: inactiveTrack.width > control.stopIndicatorSize * 3
            }
        }
    }

    handle: Item {
        x: control.leftPadding + control.visualPosition * control.availableWidth - width / 2
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: 40
        height: 48

        HoverHandler {
            id: mouseHandler
        }

        MaterialShape {
            anchors.centerIn: parent
            width: control.thumbSize
            height: control.thumbSize
            shape: mouseHandler.hovered ? MaterialShape.Cookie4Sided : MaterialShape.Square
            color: control.enabled ? control.trackColor : Qt.alpha(Theme.md3.on_surface, 0.38)
        }
    }
}