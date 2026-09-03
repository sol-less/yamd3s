import QtQuick
import QtQuick.Layouts
import Yamd3s

Item {
    Layout.fillWidth: true
    Layout.preferredHeight: rows.height

    RowLayout {
        id: rows

        anchors.centerIn: parent
        spacing: 10

        Indicator {
            job: SystemMonitor.cpuUsage
            icon: "\ue322"
        }

        Indicator {
            job: SystemMonitor.diskUsage
            icon: "\ue1db"
        }

        Indicator {
            job: SystemMonitor.batteryPercent
            icon: "\uf304"
        }

    }

    component Indicator: ColumnLayout {
        id: componentRoot

        property var icon
        property var job

        Progress {
            Layout.alignment: Qt.AlignHCenter
            mode: "circular"
            type: "normal"
            value: componentRoot.job / 100
            size: 96
            strokeWidth: 6

            Text {
                anchors.centerIn: parent
                text: componentRoot.job + "%"
                color: Theme.md3.secondary
                font.family: "Google Sans"
                font.weight: 500
                font.pixelSize: 16
            }

        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            font.family: "Material Symbols Rounded"
            text: componentRoot.icon
            color: Theme.md3.secondary
            font.pixelSize: 16
        }

    }

}
