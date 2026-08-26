import M3Shapes
import QtQuick
import QtQuick.Effects
import Yamd3s.UI


Item {
    id: root

    readonly property var shapePool: [MaterialShape.Cookie4Sided, MaterialShape.Cookie6Sided, MaterialShape.Cookie9Sided, MaterialShape.Sunny, MaterialShape.VerySunny, MaterialShape.Flower, MaterialShape.Boom, MaterialShape.Pentagon, MaterialShape.Gem, MaterialShape.Heart, MaterialShape.Squircle]
    property int currentShapeIndex: Math.floor(Math.random() * shapePool.length)
    property string oldArtUrl: ""
    property string newArtUrl: ""

    implicitWidth: 80
    implicitHeight: 80
    Component.onCompleted: {
        root.newArtUrl = Variable.track.artUrl;
    }

    Connections {
        function onArtUrlChanged() {
            const incomingUrl = Variable.track.artUrl;
            if (!incomingUrl || incomingUrl === root.newArtUrl)
                return ;

            root.oldArtUrl = root.newArtUrl;
            root.newArtUrl = incomingUrl;
            root.currentShapeIndex = Math.floor(Math.random() * root.shapePool.length);
            newImage.opacity = 0;
            fadeAnimation.restart();
        }

        target: Variable.track
    }

    Item {
        id: imageContainer

        anchors.fill: parent
        layer.enabled: true
        visible: false

        Image {
            id: oldImage

            anchors.fill: parent
            source: root.oldArtUrl
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            sourceSize.width: 160
            sourceSize.height: 160
        }

        Image {
            id: newImage

            anchors.fill: parent
            source: root.newArtUrl
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            sourceSize.width: 160
            sourceSize.height: 160
            opacity: 1
        }

    }

    NumberAnimation {
        id: fadeAnimation

        target: newImage
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }

    MaterialShape {
        id: materialHandler

        anchors.fill: parent
        layer.enabled: true
        visible: false
        shape: root.shapePool[root.currentShapeIndex]
        animationDuration: 550
        animationEasing.type: Easing.OutBack
    }

    MultiEffect {
        anchors.fill: parent
        source: imageContainer
        maskEnabled: true
        maskSource: materialHandler
    }

}
