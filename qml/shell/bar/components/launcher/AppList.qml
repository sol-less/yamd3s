import QtQuick
import "."
import Yamd3s

GridView {
    id: root

    property var appRefCurrent: currentItem?.app_ref ?? null
    signal appActivated(var app)
    required property bool gridMode

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
