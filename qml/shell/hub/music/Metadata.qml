import Yamd3s
import QtQuick
import QtQuick.Layouts
import qs.qml.shell.hub.music

ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

    Repeater {
        model: [{
            "text": Variable.track.title
        }, {
            "text": Variable.track.artist
        }]

        delegate: Text {
            text: modelData.text
            verticalAlignment: Text.AlignVCenter
            color: index === 0 ? Theme.md3.on_surface : Theme.md3.on_surface_variant
            font.family: "Google Sans"
            font.weight: 500
            font.pixelSize: index === 0 ? 16 : 12
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

    }

}
