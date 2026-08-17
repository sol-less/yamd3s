import QtQuick
import QtQuick.Layouts
import Quickshell
import Y3s.Globals
import Y3s.Tokens
import qs.dashboard.launcher

Item {
    property bool notFocus: search_bar.text.length === 0

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
            States.dashboardClose();
        }

        anchors.fill: parent
        spacing: 12

        Search {
            id: search_bar

            onEscape_pressed: search_bar.clearOpen()
            onMove_down: app_list.incrementCurrentIndex()
            onMove_up: app_list.decrementCurrentIndex()
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
            onApp_activated: (app) => {
                return rootColumn.activate_app(app);
            }
        }

    }

}
