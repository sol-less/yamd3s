import QtQuick
import QtQuick.Controls.Basic
import Y3s.Tokens

Button {
    id: control

    text: "Hi"
    enabled: true

    contentItem: Text {
        text: control.text
        font.family: "Google Sans"
        color: enabled ? Colors.roleColor("actionsButton", "on") : Colors.md3.outline
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        radius: 6
        color: enabled ? Colors.roleColor("actionsButton") : Colors.md3.surface_container_high
        border.color: enabled ? "transparent" : Colors.md3.outline
        border.width: enabled ? 0 : 2
    }

}
