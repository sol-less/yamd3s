import QtQuick
import QtQuick.Controls.Basic
import Y3s.Tokens

Slider {
    id: control

    property int trackHeight: 28
    property int thumbWidthBase: 4
    property int thumbWidthPressed: 2
    property int thumbHeight: 44
    property int gapSize: implicitHeight / 4
    property int stopIndicatorSize: 4
    property int trackRadii: 0
    property var trackColor: Colors.md3.secondary

    value: 0.5
    from: 0
    to: 100
    implicitWidth: 200
    implicitHeight: 48

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
            width: Math.max(0, control.visualPosition * parent.width - (control.gapSize / 2))
            anchors.verticalCenter: parent.verticalCenter
            bottomLeftRadius: control.trackRadii
            topLeftRadius: control.trackRadii
            color: control.enabled ? control.trackColor : Qt.alpha(Colors.md3.on_surface, 0.38)
        }

        Rectangle {
            id: inactiveTrack

            x: control.visualPosition * parent.width + (control.gapSize / 2)
            y: 0
            height: trackHeight
            width: Math.max(0, parent.width - x)
            anchors.verticalCenter: parent.verticalCenter
            bottomRightRadius: control.trackRadii
            topRightRadius: control.trackRadii
            color: control.enabled ? Colors.md3.surface_variant : Qt.alpha(Colors.md3.on_surface, 0.12)

            Rectangle {
                width: control.stopIndicatorSize
                height: control.stopIndicatorSize
                radius: width / 2
                anchors.right: parent.right
                anchors.rightMargin: (parent.height - width) / 2
                anchors.verticalCenter: parent.verticalCenter
                color: Colors.md3.surface
                visible: inactiveTrack.width > control.stopIndicatorSize * 3
            }

        }

    }

    handle: Item {
        x: control.leftPadding + control.visualPosition * control.availableWidth - width / 2
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: 40
        height: 48

        Rectangle {
            anchors.centerIn: parent
            implicitWidth: control.pressed ? control.thumbWidthPressed : control.thumbWidthBase
            implicitHeight: control.thumbHeight
            radius: width / 2
            color: control.enabled ? control.trackColor : Qt.alpha(Colors.md3.on_surface, 0.38)
        }

    }

}
