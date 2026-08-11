import M3Shapes
import QtQuick
import QtQuick.Layouts
import Quickshell
import Y3s.Tokens

Rectangle {
    id: root

    property LockContext context: null
    readonly property var indicatorShapes: [MaterialShape.Triangle, MaterialShape.Square, MaterialShape.Circle, MaterialShape.Pentagon, MaterialShape.Arrow]
    readonly property bool hasContext: context !== null && context !== undefined

    color: Colors.md3.background

    ListModel {
        id: indicatorModel
    }

    Connections {
        function onCurrentTextChanged() {
            if (!root.hasContext) {
                indicatorModel.clear();
                return ;
            }
            var targetLen = root.context.currentText.length;
            while (indicatorModel.count < targetLen)
                indicatorModel.append({
                    "shapeIndex": indicatorModel.count
                });

            while (indicatorModel.count > targetLen)
                indicatorModel.remove(indicatorModel.count - 1);

        }

        target: root.context
    }

    TextInput {
        id: passwordCapture

        focus: true
        width: 0
        height: 0
        opacity: 0
        enabled: hasContext ? !root.context.unlockInProgress : false
        echoMode: TextInput.Password
        inputMethodHints: Qt.ImhSensitiveData
        Component.onCompleted: forceActiveFocus()
        onTextChanged: {
            if (root.hasContext)
                root.context.currentText = text;

        }
        Keys.onReturnPressed: {
            if (root.hasContext)
                root.context.tryUnlock();

        }
        Keys.onEscapePressed: {
            text = "";
            if (root.hasContext)
                root.context.currentText = "";

        }

        Connections {
            function onCurrentTextChanged() {
                if (root.hasContext && root.context.currentText !== passwordCapture.text)
                    passwordCapture.text = root.context.currentText;

            }

            target: root.context
        }

    }

    MouseArea {
        anchors.fill: parent
        onClicked: passwordCapture.forceActiveFocus()
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 32

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDateTime(new Date(), "hh:mm")
            font.family: "Google Sans"
            font.pixelSize: 72
            font.weight: 300
            color: Colors.md3.on_background

            Timer {
                running: true
                repeat: true
                interval: 1000
                onTriggered: parent.text = Qt.formatDateTime(new Date(), "hh:mm")
            }

        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDateTime(new Date(), "dddd, dd MMMM")
            font.family: "Google Sans"
            font.pixelSize: 18
            color: Colors.md3.on_surface_variant

            Timer {
                running: true
                repeat: true
                interval: 60000
                onTriggered: parent.text = Qt.formatDateTime(new Date(), "dddd, dd MMMM")
            }

        }

        RowLayout {
            id: indicatorRow

            Layout.alignment: Qt.AlignHCenter
            spacing: 12

            Repeater {
                model: indicatorModel

                delegate: MaterialShape {
                    id: indicator

                    required property int shapeIndex

                    width: 18
                    height: 18
                    Layout.preferredWidth: 0
                    shape: Math.floor(Math.random() * root.indicatorShapes.length)
                    color: (root.hasContext && root.context.showFailure) ? Colors.md3.error : Colors.md3.primary
                    scale: 0
                    rotation: 90
                    x: root.indicatorShapes.length
                    Component.onCompleted: {
                        expandWidthAnim.start();
                        scale = 1;
                        rotation = 0;
                    }

                    NumberAnimation {
                        id: expandWidthAnim

                        target: indicator
                        property: "Layout.preferredWidth"
                        to: 18
                        duration: 250
                        easing.type: Easing.OutQuint
                    }

                    Behavior on x {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutBack
                        }

                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutBack
                        }

                    }

                    Behavior on rotation {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutBack
                        }

                    }

                }

            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                visible: indicatorModel.count === 0
                text: "Type to unlock"
                font.family: "Google Sans"
                font.pixelSize: 14
                color: Colors.md3.on_surface_variant
                opacity: 0.6
            }

        }

        Connections {
            function onFailed() {
                shakeAnim.start();
            }

            target: root.context
        }

        SequentialAnimation {
            id: shakeAnim

            NumberAnimation {
                target: indicatorRow
                property: "x"
                to: -12
                duration: 50
            }

            NumberAnimation {
                target: indicatorRow
                property: "x"
                to: 12
                duration: 50
            }

            NumberAnimation {
                target: indicatorRow
                property: "x"
                to: -8
                duration: 50
            }

            NumberAnimation {
                target: indicatorRow
                property: "x"
                to: 8
                duration: 50
            }

            NumberAnimation {
                target: indicatorRow
                property: "x"
                to: 0
                duration: 50
            }

        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            visible: root.hasContext && root.context.showFailure
            text: "Incorrect password"
            font.family: "Google Sans"
            font.pixelSize: 14
            color: Colors.md3.error

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }

            }

        }

    }

}
