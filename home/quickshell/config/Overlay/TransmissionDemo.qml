import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: root

    readonly property color panelColor: "#353331"
    readonly property color titleColor: "#2a2927"
    readonly property color ink: "#ded8c8"
    readonly property color mutedInk: "#aaa597"
    readonly property color rule: "#f1ead6"

    color: "transparent"
    implicitWidth: 660
    implicitHeight: 280
    surfaceFormat.opaque: false

    exclusionMode: ExclusionMode.Ignore
    focusable: false
    WlrLayershell.layer: WlrLayer.Background

    anchors {
        top: true
        right: true
    }

    margins {
        top: 96
        right: 96
    }

    Item {
        id: transmission

        anchors.centerIn: parent
        width: 590
        height: 215

        transform: [
            Rotation {
                origin.x: transmission.width / 2
                origin.y: transmission.height / 2

                axis {
                    x: 1
                    y: 0
                    z: 0
                }

                angle: -2.5
                distanceToPlane: 1000
            },
            Rotation {
                origin.x: transmission.width / 2
                origin.y: transmission.height / 2

                axis {
                    x: 0
                    y: 1
                    z: 0
                }

                angle: -4
                distanceToPlane: 1000
            },
            Rotation {
                origin.x: transmission.width / 2
                origin.y: transmission.height / 2
                angle: 0.6
            }
        ]

        Rectangle {
            x: card.x + 8
            y: card.y + 10
            width: card.width
            height: card.height

            color: "#000000"
            opacity: 0.3
        }

        Rectangle {
            id: card

            readonly property int dividerX: 418

            x: 0
            y: 15
            width: parent.width
            height: 184

            color: root.panelColor
            opacity: 0.84
            clip: false

            // Subtle scanlines keep the card from looking like a flat desktop widget.
            Repeater {
                model: 24

                Rectangle {
                    required property int index

                    x: 0
                    y: index * 8
                    width: card.width
                    height: 1

                    color: root.rule
                    opacity: 0.025
                }
            }

            // The title strip is part of the card and meets its top edge.
            Rectangle {
                id: titleBar

                x: 3
                y: 0
                width: card.width - 6
                height: 31

                color: root.titleColor
                opacity: 0.92

                Text {
                    anchors {
                        left: parent.left
                        leftMargin: 40
                        verticalCenter: parent.verticalCenter
                    }

                    text: "POD 042  //  COMMUNICATION CHANNEL"
                    color: root.ink
                    font.family: "PragmataPro"
                    font.pixelSize: 11
                    font.letterSpacing: 1.4
                    font.weight: Font.DemiBold
                }

                Item {
                    anchors {
                        left: parent.left
                        leftMargin: 14
                        verticalCenter: parent.verticalCenter
                    }

                    width: 18
                    height: 18

                    Rectangle {
                        anchors.centerIn: parent
                        width: 18
                        height: 18
                        color: root.rule
                        opacity: 0.08
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: 12
                        height: 12
                        color: root.rule
                        opacity: 0.72
                    }
                }

                Row {
                    anchors {
                        right: parent.right
                        rightMargin: 13
                        verticalCenter: parent.verticalCenter
                    }

                    spacing: 4

                    Repeater {
                        model: 4

                        Rectangle {
                            required property int index

                            anchors.bottom: parent.bottom
                            width: 3
                            height: 4 + index * 2
                            color: root.ink
                            opacity: 0.82
                        }
                    }
                }
            }

            // Only the outer vertical edges are fully ruled.
            Rectangle {
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }

                width: 3
                color: root.rule
                opacity: 0.95
            }

            Rectangle {
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }

                width: 3
                color: root.rule
                opacity: 0.95
            }

            // The center divider terminates before the top and bottom points.
            Rectangle {
                x: card.dividerX - 1
                y: 50
                width: 2
                height: parent.height - 70

                color: root.rule
                opacity: 0.9
            }

            Item {
                id: dataPanel

                x: 18
                y: 42
                width: card.dividerX - x - 18
                height: card.height - y - 15

                Text {
                    text: "TRANSMISSION RECEIVED"
                    color: root.ink
                    font.family: "PragmataPro"
                    font.pixelSize: 12
                    font.letterSpacing: 1.6
                    font.weight: Font.DemiBold
                }

                Text {
                    anchors {
                        right: parent.right
                        top: parent.top
                    }

                    text: "SIG 82%"
                    color: root.mutedInk
                    font.family: "PragmataPro"
                    font.pixelSize: 10
                    font.letterSpacing: 1
                }

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    y: 24
                    height: 2
                    color: root.rule
                    opacity: 0.78
                }

                Rectangle {
                    y: 31
                    width: parent.width * 0.64
                    height: 2
                    color: root.mutedInk
                    opacity: 0.55
                }

                Text {
                    y: 48
                    width: parent.width

                    text: "Message received.\nDirective scaffold initialized."
                    color: root.ink
                    font.family: "PragmataPro"
                    font.pixelSize: 14
                    font.letterSpacing: 0.7
                    lineHeight: 1.35
                }

                Row {
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                    }

                    spacing: 8

                    Repeater {
                        model: 5

                        Rectangle {
                            width: 26
                            height: 11
                            color: root.ink
                            opacity: 0.7
                        }
                    }
                }

                Text {
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                    }

                    text: "CH 01  •  12.84 kHz"
                    color: root.mutedInk
                    font.family: "PragmataPro"
                    font.pixelSize: 9
                    font.letterSpacing: 1
                }
            }

            Item {
                id: avatarPanel

                x: card.dividerX + 16
                y: 42
                width: card.width - x - 18
                height: card.height - y - 15

                Rectangle {
                    anchors.fill: parent
                    color: root.rule
                    opacity: 0.055
                }

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                    }

                    height: 1
                    color: root.rule
                    opacity: 0.3
                }

                Rectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    height: 1
                    color: root.rule
                    opacity: 0.3
                }

                Text {
                    anchors.centerIn: parent

                    text: "AVATAR"
                    color: root.mutedInk
                    opacity: 0.72
                    font.family: "PragmataPro"
                    font.pixelSize: 14
                    font.letterSpacing: 3
                }

                Text {
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: 9
                    }

                    text: "OPERATOR 042"
                    color: root.mutedInk
                    opacity: 0.7
                    font.family: "PragmataPro"
                    font.pixelSize: 9
                    font.letterSpacing: 1.3
                }
            }

            // Bright registration lights: corners plus the divider intersections.
            Repeater {
                model: [
                    { x: 11, y: titleBar.height + 7 },
                    { x: card.dividerX, y: titleBar.height + 7 },
                    { x: card.width - 11, y: titleBar.height + 7 },
                    { x: 11, y: card.height - 11 },
                    { x: card.dividerX, y: card.height - 11 },
                    { x: card.width - 11, y: card.height - 11 }
                ]

                Item {
                    required property var modelData

                    x: modelData.x - width / 2
                    y: modelData.y - height / 2
                    width: 18
                    height: 18

                    Rectangle {
                        anchors.centerIn: parent
                        width: 16
                        height: 16
                        radius: 8
                        color: root.rule
                        opacity: 0.1
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: 9
                        height: 9
                        radius: 4.5
                        color: root.rule
                        opacity: 0.22
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: 4
                        height: 4
                        radius: 2
                        color: root.rule
                    }
                }
            }
        }
    }
}
