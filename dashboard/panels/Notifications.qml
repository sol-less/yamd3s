import QtQuick
import QtQuick.Layouts
import Quickshell
import Y3s.Tokens
import qs.dashboard.notifications

Item {
    implicitWidth: Metrics.panelSizes.notifications.width
    implicitHeight: Metrics.panelSizes.notifications.height

    ColumnLayout {
        width: parent.width
        spacing: 6

        Repeater {
            model: NotifServer.trackedNotifications

            delegate: Notifs {
                required property var modelData

                notification: modelData
            }

        }

    }

}
