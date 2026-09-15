pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    property var workspaces: []
    property var windows: []

    function workspacesFor(output: string): var {
        return workspaces
            .filter(ws => ws.output === output)
            .sort((a, b) => a.idx - b.idx)
    }

    function activeWindowFor(output: string): var {
        const ws = workspaces.find(ws => ws.is_active && ws.output === output)

        if (!ws || ws.active_window_id === null) return null

        return windows.find(w => w.id === ws.active_window_id)
    }

    function focusWorkspace(id: int): void {
        const request = {
            Action: {
                FocusWorkspace: {
                    reference: {
                        Id: id
                    }
                }
            }
        }

        commandSocket.write(JSON.stringify(request) + "\n")
        commandSocket.flush()
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
                } else if ("WorkspaceActiveWindowChanged" in event) {
                    const change = event.WorkspaceActiveWindowChanged

                    workspaces = workspaces.map(ws => {
                        if (ws.id !== change.workspace_id) return ws

                        return Object.assign({}, ws, {
                            active_window_id: change.active_window_id
                        })
                    })
                } else if ("WindowsChanged" in event) {
                    windows = event.WindowsChanged.windows
                } else if ("WindowOpenedOrChanged" in event) {
                    const changed = event.WindowOpenedOrChanged.window
                    windows = windows.filter(w => w.id !== changed.id).concat([changed])
                } else if ("WindowClosed" in event) {
                    const id = event.WindowClosed.id
                    windows = windows.filter(win => win.id !== id)
                }
            }
        }
    }

    Socket {
        id: commandSocket
        path: Quickshell.env("NIRI_SOCKET")
        connected: true
    }
}
