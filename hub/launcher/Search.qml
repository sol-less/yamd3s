import QtQuick
import QtQuick.Layouts
import Y3s.Globals
import Y3s.Tokens

Item {
    id: root

    property alias text: searchField.text

    signal escapePressed()
    signal moveDown()
    signal moveUp()
    signal moveLeft()
    signal moveRight()
    signal confirm()

    function focusInput() {
        searchField.forceActiveFocus();
    }

    function clear() {
        searchField.text = "";
    }

    function clearOpen() {
        searchField.focus = null;
        root.clear();
    }

    Layout.fillWidth: true
    Layout.preferredHeight: 36

    Rectangle {
        id: holder

        property bool isOpen: hoverHandler.hovered || (text.length > 0 || searchField.activeFocus)

        color: Colors.md3.surface_container_high
        radius: height / 2
        height: isOpen ? 36 : 12
        width: isOpen ? parent.width : parent.width / 3
        anchors.centerIn: parent

        Connections {
            function onDashboardActiveChanged() {
                if (States.dashboardOpen)
                    root.clear();

            }

            target: States
        }

        HoverHandler {
            id: hoverHandler
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 8

            TextInput {
                id: searchField

                Layout.fillWidth: true
                color: Colors.md3.on_surface
                font.family: "Google Sans"
                font.pixelSize: 15
                font.weight: 500
                clip: true
                Keys.onEscapePressed: root.escapePressed()
                Keys.onDownPressed: root.moveDown()
                Keys.onUpPressed: root.moveUp()
                Keys.onLeftPressed: root.moveLeft()
                Keys.onRightPressed: root.moveRight()
                Keys.onReturnPressed: root.confirm()
                opacity: holder.isOpen ? 1 : 0

                Text {
                    visible: searchField.text.length === 0
                    text: "Search apps..."
                    color: Colors.md3.outline
                    font: searchField.font
                    opacity: 0.9
                }

                MouseArea {
                    id: mouse

                    anchors.fill: parent
                    propagateComposedEvents: true
                    onClicked: {
                        mouse.accepted = false;
                        root.focusInput();
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutQuint
                    }

                }

            }

        }

        Behavior on height {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutQuint
            }

        }

        Behavior on width {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutQuint
            }

        }

    }

}
