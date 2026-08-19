import QtQuick
import qs.dashboard.launcher
import Y3s.Globals

GridView {
    id: root

    property var app_ref_current: currentItem?.app_ref ?? null
    signal appActivated(var app)
    property bool gridMode: Config.others.launcherType === "grid"

    clip: true
    currentIndex: 0
    highlightMoveDuration: 120

    cellWidth: gridMode ? Math.floor(root.width / 3) : root.width    
    cellHeight: gridMode ? Math.floor(root.height / 4) : 48
    
    flow: GridView.FlowLeftToRight

    delegate: AppEntry {
        required property var modelData
        required property int index
        width: root.cellWidth - (gridMode ? 8 : 0)
        height: root.cellHeight - (gridMode ? 8 : 0)

        app_ref: modelData
        is_current: root.currentIndex === index

        onHovered: root.currentIndex = index
        onActivated: root.appActivated(modelData)
    }
}
