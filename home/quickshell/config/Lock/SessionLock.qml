import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    id: root

    property alias locked: sessionLock.locked
    signal unlocked()

    LockContext {
        id: lockContext

        onUnlocked: {
            sessionLock.locked = false
            root.unlocked()
        }
    }

    WlSessionLock {
        id: sessionLock
        locked: false

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }

    IpcHandler {
        target: "lock"

        function activate(): void {
            if (!sessionLock.locked) {
                lockContext.reset()
                sessionLock.locked = true
            }
        }

        function isLocked(): bool {
            return sessionLock.locked
        }
    }
}
