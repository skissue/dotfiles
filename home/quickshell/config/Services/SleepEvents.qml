pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root
    
    signal preSleep()
    signal resumed()
    
    IpcHandler {
        target: "sleep"

        function prepare(): void {
            root.preSleep()
        }

        function resume(): void {
            root.resumed()
        }
    }
}
