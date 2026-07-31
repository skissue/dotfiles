import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    property string time

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            color: "#0e1415"

            anchors {
                top: true
                bottom: true
                left: true
            }

            implicitWidth: 40

            ColumnLayout {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 16

                spacing: 12

                Repeater {
                    model: ScriptModel {
                        values: Niri.workspacesFor(screen.name)
                        objectProp: "id"
                    }

                    Rectangle {
                        required property var modelData

                        readonly property bool active: modelData.is_active
                        readonly property bool empty: !active && modelData.active_window_id === null
                        
                        implicitWidth: 12
                        implicitHeight: active ? 18 : 12
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
                    }
                }
               
            }

            ColumnLayout {
                anchors.centerIn: parent

                Text {
                    color: "#cecece"
                    text: Qt.formatDateTime(clock.date, "hh")
                }

                Text {
                    color: "#cecece"
                    text: Qt.formatDateTime(clock.date, "mm")
                }


                Text {
                    color: "#cecece"
                    text: Qt.formatDateTime(clock.date, "ss")
                }
            }
        }
    }

}
