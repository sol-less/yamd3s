import M3Shapes
import QtQuick
import Y3s.Tokens

MaterialShape {
    id: root

    property bool active: false
    readonly property var shapeSequence: [MaterialShape.Cookie4Sided, MaterialShape.Pill, MaterialShape.Sunny, MaterialShape.Cookie9Sided, MaterialShape.Pentagon, MaterialShape.VerySunny, MaterialShape.Oval]
    property int sequenceIndex: 0
    property real baseRotation: 0
    property real burstRotation: 0
    property real baseScale: 1
    property real burstScaleOffset: 0

    width: 64
    height: 64
    color: Colors.md3.primary
    animationDuration: 650
    animationEasing.type: Easing.OutBack
    rotation: baseRotation + burstRotation
    scale: baseScale + burstScaleOffset

    Timer {
        interval: 1000
        running: root.active
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.sequenceIndex = (root.sequenceIndex + 1) % root.shapeSequence.length;
            root.shape = root.shapeSequence[root.sequenceIndex];
            rotationBurst.start();
            scaleBurst.start();
        }
    }

    SequentialAnimation {
        id: rotationBurst

        NumberAnimation {
            target: root
            property: "burstRotation"
            to: root.burstRotation + 35
            duration: 260
            easing.type: Easing.OutQuint
        }

    }

    SequentialAnimation {
        id: scaleBurst

        NumberAnimation {
            target: root
            property: "burstScaleOffset"
            to: root.burstScaleOffset + 0.1
            duration: 220
            easing.type: Easing.OutQuint
        }

        NumberAnimation {
            target: root
            property: "burstScaleOffset"
            to: root.burstScaleOffset
            duration: 400
            easing.type: Easing.OutQuint
        }

    }

    NumberAnimation on baseRotation {
        running: root.active
        loops: Animation.Infinite
        from: 0
        to: 360
        duration: 3200
    }

}
