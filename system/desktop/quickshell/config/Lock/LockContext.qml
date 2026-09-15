import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root

    signal unlocked()

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    onCurrentTextChanged: {
        showFailure = false
    }

    function reset(): void {
        currentText = ""
        unlockInProgress = false
        showFailure = false

        if (pam.active) pam.abort()
    }

    function tryUnlock(): void {
        if (currentText === "" || unlockInProgress) return

        unlockInProgress = true
        showFailure = false

        if (!pam.start()) {
            unlockInProgress = false
            showFailure = true
        }
    }

    PamContext {
        id: pam

        // TODO dedicated PAM profile
        config: "login"

        onPamMessage: {
            if (responseRequired) {
                respond(root.currentText)
            }
        }

        onCompleted: result => {
            root.unlockInProgress = false

            if (result === PamResult.Success) {
                root.currentText = ""
                root.unlocked()
            } else {
                root.currentText = ""
                root.showFailure = true
            }
        }
    }
}
