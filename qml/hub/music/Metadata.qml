import Yamd3s.Globals
import QtQuick
import QtQuick.Layouts
import Yamd3s.Core
import qs.qml.hub.music

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
            horizontalAlignment: Text.AlignHCenter
            color: index === 0 ? Theme.md3.on_surface : Theme.md3.on_surface_variant
            font.family: "Google Sans"
            font.weight: 500
            font.pixelSize: index === 0 ? 16 : 12
            elide: Text.ElideRight
        }

    }

}
