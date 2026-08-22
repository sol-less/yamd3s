import QtQuick
import QtQuick.Layouts
import Quickshell
import Y3s.Tokens
import qs.hub.notifications

Item {
    implicitWidth: Metrics.panelSizes.notifications.width
    implicitHeight: Metrics.panelSizes.notifications.height

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
