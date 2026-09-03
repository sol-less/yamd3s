import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root
    signal unlocked
    signal failed

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    onCurrentTextChanged: showFailure = false

    function tryUnlock() {
        if (currentText === "" || unlockInProgress)
            return;
        root.unlockInProgress = true;
        pam.active = false;
        pam.active = true;
    }

    PamContext {
        id: pam
        configDirectory: Quickshell.shellDir + "/config/pam"
        config: "password.conf"
        active: root.unlockInProgress

        onPamMessage: {
            if (this.responseRequired) {
                this.respond(root.currentText);
            }
        }

        onCompleted: result => {
            root.unlockInProgress = false;
            pam.active = false;

            // Check against PamResult enum value
            if (result === PamResult.Success) {
                root.currentText = "";
                root.showFailure = false;
                root.unlocked();
            } else {
                root.currentText = "";
                root.showFailure = true;
                root.failed();
            }
        }
    }
}
