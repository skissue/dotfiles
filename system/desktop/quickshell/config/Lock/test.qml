import Quickshell

ShellRoot {
    LockContext {
        id: lockContext
        onUnlocked: Qt.quit()
    }

    FloatingWindow {
        implicitWidth: 1280
        implicitHeight: 720

        LockSurface {
            anchors.fill: parent
            context: lockContext
        }
    }
}
