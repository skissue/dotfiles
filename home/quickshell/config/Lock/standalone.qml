import Quickshell

ShellRoot {
    SessionLock {
        locked: true

        onUnlocked: Qt.quit()
    }
}
