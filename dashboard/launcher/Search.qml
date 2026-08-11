import QtQuick
import QtQuick.Layouts
import Y3s.Globals
import Y3s.Tokens

Rectangle {
    id: root

    property alias text: search_field.text

    signal escape_pressed()
    signal move_down()
    signal move_up()
    signal confirm()

    function focusInput() {
        search_field.forceActiveFocus();
    }

    function clear() {
        search_field.text = "";
    }

    Layout.fillWidth: true
    Layout.preferredHeight: 48
    color: Colors.md3.surface_container_high
    radius: height / 2

    Connections {
        function onDashboardActiveChanged() {
            if (States.dashboardOpen)
                root.clear();

        }

        target: States
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 8

        TextInput {
            id: search_field

            Layout.fillWidth: true
            color: Colors.md3.on_surface
            font.family: "Google Sans"
            font.pixelSize: 15
            clip: true
            Keys.onEscapePressed: root.escape_pressed()
            Keys.onDownPressed: root.move_down()
            Keys.onUpPressed: root.move_up()
            Keys.onReturnPressed: root.confirm()

            Text {
                visible: search_field.text.length === 0
                text: "Search apps..."
                color: Colors.md3.outline
                font: search_field.font
                opacity: 0.9
            }

            HoverHandler {
                cursorShape: Qt.IBeamCursor
            }

        }

    }

}
