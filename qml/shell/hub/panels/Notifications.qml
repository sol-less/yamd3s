import QtQuick
import QtQuick.Layouts
import Quickshell
import Yamd3s
import qs.qml.shell.hub.notifications

Item {
    implicitWidth:  ConfigManager.vanilla["panels.notifications.width"]
    implicitHeight: ConfigManager.vanilla["panels.notifications.height"]

    ColumnLayout {
        anchors.fill: parent
        spacing: 6

        Actions {
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6
            model: NotifServer.trackedNotifications

            delegate: Notifs {
                required property var modelData

                notification: modelData
            }

        }

    }

}
