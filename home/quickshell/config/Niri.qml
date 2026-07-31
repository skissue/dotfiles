pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    property var workspaces: []

    function workspacesFor(output: string): var {
        return workspaces
            .filter(ws => ws.output === output)
            .sort((a, b) => a.idx - b.idx)
    }

    Socket {
        id: socket

        path: Quickshell.env("NIRI_SOCKET")
        connected: true

        // Start event stream on connection
        onConnectedChanged: {
            if (connected) {
                write("\"EventStream\"\n")
                flush()
            }
        }
        
        parser: SplitParser {
            onRead: data => {
                const event = JSON.parse(data)

                if ("WorkspacesChanged" in event) {
                    workspaces = event.WorkspacesChanged.workspaces
                } else if ("WorkspaceActivated" in event) {
                    const id = event.WorkspaceActivated.id
                    const focused = event.WorkspaceActivated.focused
                    const target = workspaces.find(ws => ws.id === id)

                    workspaces = workspaces.map(ws => {
                        // Clone the workspace object for proper reactivity
                        const wsNext = Object.assign({}, ws)
                        
                        // Unactivate other workspaces on the same monitor
                        // (active = per-monitor)
                        if (ws.output === target.output) {
                            wsNext.is_active = ws.id === id
                        }
                        // Unfocus all other workspaces (focus = global)
                        if (focused) {
                            wsNext.is_focused = ws.id === id
                        }

                        return wsNext
                    })
                }
            }
        }
    }
}
