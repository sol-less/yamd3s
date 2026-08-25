import QtQuick
import qs.hub.launcher
import Y3s.Globals

GridView {
    id: root

    property var app_ref_current: currentItem?.app_ref ?? null
    signal appActivated(var app)
    property bool gridMode: Config.launcher.type === "grid"

    clip: true
    currentIndex: 0
    highlightMoveDuration: 120

    cellWidth: gridMode ? Math.floor(root.width / 3) : root.width    
    cellHeight: gridMode ? Math.floor(root.height / 4) : 48
    
    flow: GridView.FlowLeftToRight

    delegate: AppEntry {
        required property var modelData
        required property int index
        width: root.cellWidth
        height: root.cellHeight

        app_ref: modelData
        is_current: root.currentIndex === index

        onHovered: root.currentIndex = index
        onActivated: root.appActivated(modelData)
    }
}
