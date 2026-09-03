import Yamd3s
import QtQuick

Item {
    id: root

    property real lowValue: 0.3
    property real highValue: 0.7
    property real trackHeight: 4
    property real handleWidth: 3
    property real handleHeight: 20
    property real dotSize: 4
    property color trackColorActive: Theme.md3.primary
    property color trackColorInactive: Theme.md3.surface_container_highest
    property color handleColor: Theme.md3.primary
    property color dotColor: Theme.md3.on_surface_variant

    signal lowMoved(real v)
    signal highMoved(real v)

    implicitHeight: Math.max(trackHeight, handleHeight)

    // full inactive track
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: parent.width
        implicitHeight: root.trackHeight
        radius: height / 2
        color: root.trackColorInactive
    }

    // active window between the two handles
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: root.lowValue * parent.width
        implicitWidth: (root.highValue - root.lowValue) * parent.width
        implicitHeight: root.trackHeight
        color: root.trackColorActive

        Behavior on x {
            enabled: !lowDrag.pressed

            SpringAnimation {
                spring: 3.2
                damping: 0.3
                mass: 1
                epsilon: 0.25
            }

        }

        Behavior on width {
            enabled: !highDrag.pressed

            SpringAnimation {
                spring: 3.2
                damping: 0.3
                mass: 1
                epsilon: 0.25
            }

        }

    }

    // end dots (absolute min/max markers)
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: -dotSize / 2
        implicitWidth: root.dotSize
        implicitHeight: root.dotSize
        radius: width / 2
        color: root.dotColor
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: parent.width - dotSize / 2
        implicitWidth: root.dotSize
        implicitHeight: root.dotSize
        radius: width / 2
        color: root.dotColor
    }

    // low handle (vertical bar)
    Rectangle {
        id: lowHandle

        implicitWidth: root.handleWidth
        implicitHeight: lowDrag.pressed ? root.handleHeight * 1.2 : root.handleHeight
        radius: width / 2
        color: root.handleColor
        anchors.verticalCenter: parent.verticalCenter
        x: root.lowValue * (parent.width - width)

        Behavior on height {
            SpringAnimation {
                spring: 3.5
                damping: 0.35
                mass: 1
                epsilon: 0.25
            }

        }

        Behavior on x {
            enabled: !lowDrag.pressed

            SpringAnimation {
                spring: 3.2
                damping: 0.3
                mass: 1
                epsilon: 0.25
            }

        }

    }

    MouseArea {
        id: lowDrag

        function update(mx) {
            const localX = lowHandle.x + mx - width / 2;
            let frac = Math.max(0, Math.min(root.highValue, localX / (root.width - lowHandle.width)));
            root.lowValue = frac;
            root.lowMoved(frac);
        }

        implicitWidth: root.handleHeight * 1.5
        implicitHeight: root.handleHeight * 1.5
        anchors.centerIn: lowHandle
        onPressed: (m) => {
            return update(m.x);
        }
        onPositionChanged: (m) => {
            if (pressed)
                update(m.x);

        }
    }

    // high handle (vertical bar)
    Rectangle {
        id: highHandle

        implicitWidth: root.handleWidth
        implicitHeight: highDrag.pressed ? root.handleHeight * 1.2 : root.handleHeight
        radius: width / 2
        color: root.handleColor
        anchors.verticalCenter: parent.verticalCenter
        x: root.highValue * (parent.width - width)

        Behavior on height {
            SpringAnimation {
                spring: 3.5
                damping: 0.35
                mass: 1
                epsilon: 0.25
            }

        }

        Behavior on x {
            enabled: !highDrag.pressed

            SpringAnimation {
                spring: 3.2
                damping: 0.3
                mass: 1
                epsilon: 0.25
            }

        }

    }

    MouseArea {
        id: highDrag

        function update(mx) {
            const localX = highHandle.x + mx - width / 2;
            let frac = Math.max(root.lowValue, Math.min(1, localX / (root.width - highHandle.width)));
            root.highValue = frac;
            root.highMoved(frac);
        }

        implicitWidth: root.handleHeight * 1.5
        implicitHeight: root.handleHeight * 1.5
        anchors.centerIn: highHandle
        onPressed: (m) => {
            return update(m.x);
        }
        onPositionChanged: (m) => {
            if (pressed)
                update(m.x);

        }
    }

    Behavior on lowValue {
        enabled: !lowDrag.pressed

        SpringAnimation {
            spring: 3.2
            damping: 0.3
            mass: 1
            epsilon: 0.005
        }

    }

    Behavior on highValue {
        enabled: !highDrag.pressed

        SpringAnimation {
            spring: 3.2
            damping: 0.3
            mass: 1
            epsilon: 0.005
        }

    }

}
