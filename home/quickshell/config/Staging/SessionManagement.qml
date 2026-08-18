pragma Singleton

import Quickshell

Singleton {
    id: root

    // TODO natively call the function
    function lock(): void {
        Quickshell.execDetached(["loginctl", "lock-session"])
    }

    function turnOffDisplays(): void {
        Quickshell.execDetached(["niri", "msg", "action", "power-off-monitors"])
    }

    function suspend(): void {
        Quickshell.execDetached(["systemctl", "suspend"])
    }

    function hibernate(): void {
        Quickshell.execDetached(["systemctl", "hibernate"])
    }

    function reloadShell(): void {
        Quickshell.reload(false)
    }

    function logOut(): void {
        Quickshell.execDetached(["uwsm", "stop"])
    }

    function reboot(): void {
        Quickshell.execDetached(["systemctl", "reboot"])
    }

    function powerOff(): void {
        Quickshell.execDetached(["systemctl", "poweroff"])
    }
}
