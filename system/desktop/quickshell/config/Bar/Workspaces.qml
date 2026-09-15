import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Services
            
ColumnLayout {
    id: root

    required property string output
    
    spacing: 12

    Repeater {
        model: ScriptModel {
            values: Niri.workspacesFor(output)
            objectProp: "id"
        }

        Rectangle {
            required property var modelData

            readonly property bool active: modelData.is_active
            readonly property bool empty: !active && modelData.active_window_id === null
                        
            implicitWidth: 12
            implicitHeight: active ? 20 : 12
            radius: width / 2
                        
            // Has windows = filled circle, no windows = hollow circle
            color: {
                if (active) return "#cd974b"
                if (empty) return "transparent"
                return "#cecece"
            }
                        
            border.color: "#cecece"
            border.width: empty ? 1 : 0

            Behavior on implicitHeight {
                NumberAnimation {
                    duration: 60
                }
            }

            TapHandler {
                onTapped: Niri.focusWorkspace(modelData.id)
            }
        }
    }
               
}
