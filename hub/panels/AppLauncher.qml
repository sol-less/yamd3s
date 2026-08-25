import QtQuick
import QtQuick.Layouts
import Quickshell
import Y3s.Globals
import Y3s.Tokens
import qs.hub.launcher

Item {
    id: root

    property bool notFocus: search_bar.text.length === 0
    property bool isGridMode: Config.launcherType === "grid"

    implicitWidth: Metrics.panelSizes.apps.width
    implicitHeight: Metrics.panelSizes.apps.height

    ColumnLayout {
        id: rootColumn

        property var allApps: DesktopEntries.applications.values
        property var filteredApps: {
            const query = search_bar.text.toLowerCase();
            if (query.length === 0)
                return allApps;

            return allApps.filter((app) => {
                return app.name.toLowerCase().includes(query);
            });
        }

        function activate_app(app) {
            app.execute();
            States.hubClose();
        }

        anchors.fill: parent
        spacing: 12

        Search {
            id: search_bar

            onEscapePressed: search_bar.clearOpen()
            onMoveDown: app_list.moveCurrentIndexDown()
            onMoveUp: app_list.moveCurrentIndexUp()
            onMoveLeft: root.isGridMode ? app_list.moveCurrentIndexLeft() : null
            onMoveRight: root.isGridMode ? app_list.moveCurrentIndexRight() : null
            onConfirm: {
                if (app_list.app_ref_current)
                    rootColumn.activate_app(app_list.app_ref_current);

            }
        }

        AppList {
            id: app_list

            Layout.fillWidth: true
            Layout.fillHeight: true
            model: rootColumn.filteredApps
            onAppActivated: (app) => {
                return rootColumn.activate_app(app);
            }
        }

    }

}
