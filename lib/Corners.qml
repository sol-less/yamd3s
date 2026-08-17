import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    property int corner: 0
    property real r: 24
    property color fillColor: "black"

    width: r
    height: r
    clip: true
    rotation: corner * 90
    transformOrigin: Item.Center
    layer.enabled: true
    layer.samples: 4

    ShapePath {
        id: shapePath

        fillColor: root.fillColor
        strokeColor: "transparent"
        strokeWidth: 0
        startX: 0
        startY: 0

        PathLine {
            x: root.r
            y: 0
        }

        PathLine {
            x: root.r
            y: root.r
        }

        PathLine {
            x: 0
            y: root.r
        }

        PathLine {
            x: 0
            y: 0
        }

        PathMove {
            x: root.r * 2
            y: root.r
        }

        PathAngleArc {
            centerX: root.r
            centerY: root.r
            radiusX: root.r
            radiusY: root.r
            startAngle: 0
            sweepAngle: 360
        }

    }

}
