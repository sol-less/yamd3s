import QtQuick
import QtQuick.Layouts
import qs.qml.shell.hub.notifications
import Yamd3s

Item {
    id: root

    Layout.preferredWidth: row.implicitWidth + 6
    Layout.preferredHeight: row.implicitHeight
    Layout.alignment: Qt.AlignHCenter

    Rectangle {
        color: Theme.md3.surface_container_high
        anchors.fill: parent
        radius: height / 2
    }

    RowLayout {
        id: row

        anchors.centerIn: parent

        QuickButton {
            text: "\ue872"
            isToggle: true
            isActive: false
            implicitWidth: 36
            implicitHeight: 36
            onClicked: {
                // 1. Grab the actual JavaScript array using .values
                let notifList = NotifServer.trackedNotifications.values;
                // 2. Loop backwards through the length of that array
                for (let i = notifList.length - 1; i >= 0; i--) {
                    let notif = notifList[i];
                    if (notif)
                        notif.dismiss();
 // Alternatively, you can use: notif.tracked = false;
                }
            }
        }

        Repeater {
            model: [{
                "label": "Do Not Disturb",
                "action": () => {
                    NotifServer.dnd = !NotifServer.dnd;
                }
            }]

            delegate: Switch {
                required property var modelData

                contentText: modelData.label
                checked: NotifServer.dnd
                onToggled: {
                    modelData.action();
                }
            }

        }

    }

}
