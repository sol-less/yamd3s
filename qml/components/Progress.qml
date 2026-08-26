import QtQuick
import QtQuick.Shapes
import Yamd3s.Core

Item {
    id: root

    property real value: 0.4
    property string mode: "circular" // "circular" | "straight"
    property string type: "normal" // "normal" | "squiggly"
    property bool slideable: false
    property real size: 64
    property real strokeWidth: 3
    property color trackColor: Theme.md3.surface_container_highest
    property color progressColor: Theme.md3.primary
    property real squiggleAmplitude: 2
    property real squiggleFrequency: 14

    signal moved(real newValue)

    function circularProgressPath(frac) {
        if (frac <= 0)
            return "";

        const cx = root.width / 2, cy = root.height / 2;
        // Lock the base radius to 'size' instead of root.width/root.height
        const r = root.size / 2 - strokeWidth / 2;
        const startAngle = -Math.PI / 2;
        const sweep = frac * Math.PI * 2;
        const steps = Math.max(24, Math.floor(frac * 200));
        let path = "";
        for (let i = 0; i <= steps; i++) {
            const t = i / steps;
            const angle = startAngle + sweep * t;
            const wobble = Math.sin(t * Math.PI * 2 * squiggleFrequency * frac) * squiggleAmplitude;
            const rr = r + wobble;
            const x = cx + rr * Math.cos(angle);
            const y = cy + rr * Math.sin(angle);
            path += (i === 0 ? `M ${x},${y}` : ` L ${x},${y}`);
        }
        return path;
    }

    function straightProgressPath(frac) {
        const w = root.width * frac;
        const midY = root.height / 2;
        if (frac <= 0)
            return `M 0,${midY} L 0,${midY}`;

        if (type === "normal")
            return `M 0,${midY} L ${w},${midY}`;

        const steps = Math.max(12, Math.floor(w / 4));
        let path = `M 0,${midY}`;
        for (let i = 1; i <= steps; i++) {
            const x = (w * i) / steps;
            const wobble = Math.sin((x / root.width) * Math.PI * 2 * squiggleFrequency) * squiggleAmplitude;
            path += ` L ${x},${midY + wobble}`;
        }
        return path;
    }

    width: mode === "circular" ? size + (type === "squiggly" ? squiggleAmplitude * 2 : 0) : size
    height: (mode === "circular" ? size : strokeWidth * 3) + (type === "squiggly" ? squiggleAmplitude * 2 : 0)

    Shape {
        visible: root.mode === "circular"
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 4

        ShapePath {
            strokeColor: root.trackColor
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root.size / 2 - root.strokeWidth / 2
                radiusY: radiusX
                startAngle: -90
                sweepAngle: 360
            }

        }

        ShapePath {
            strokeColor: root.type === "normal" ? root.progressColor : "transparent"
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root.size / 2 - root.strokeWidth / 2
                radiusY: radiusX
                startAngle: -90
                sweepAngle: root.type === "normal" ? root.value * 360 : 0
            }

        }

        ShapePath {
            strokeColor: root.type === "squiggly" ? root.progressColor : "transparent"
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathSvg {
                path: root.type === "squiggly" ? root.circularProgressPath(root.value) : ""
            }

        }

    }

    // ---- straight ----
    Shape {
        visible: root.mode === "straight"
        anchors.fill: parent

        ShapePath {
            strokeColor: root.trackColor
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathSvg {
                path: `M 0,${root.height / 2} L ${root.width},${root.height / 2}`
            }

        }

        ShapePath {
            strokeColor: root.progressColor
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathSvg {
                path: root.straightProgressPath(root.value)
            }

        }

    }

    MouseArea {
        id: dragArea

        property alias isDragging: dragArea.pressed

        function updateFromPos(mx, my) {
            let frac;
            if (root.mode === "circular") {
                const cx = root.width / 2, cy = root.height / 2;
                let angle = Math.atan2(my - cy, mx - cx) + Math.PI / 2;
                if (angle < 0)
                    angle += Math.PI * 2;

                frac = angle / (Math.PI * 2);
            } else {
                frac = mx / root.width;
            }
            frac = Math.max(0, Math.min(1, frac));
            root.value = frac;
            root.moved(frac);
        }

        anchors.fill: parent
        enabled: root.slideable
        cursorShape: root.slideable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onPressed: (mouse) => {
            return updateFromPos(mouse.x, mouse.y);
        }
        onPositionChanged: (mouse) => {
            if (pressed)
                updateFromPos(mouse.x, mouse.y);

        }
    }

    Behavior on value {
        enabled: !dragArea.pressed

        SpringAnimation {
            spring: 3.2
            damping: 0.35
            mass: 1
            epsilon: 0.005
        }

    }

}
