pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQml
import qs.Services

Rectangle {
    id: root

    required property LockContext context
    property list<string> messages: [
        "Commencing System Check",
        "Memory Unit: Green",
        "Initializing Tactics Log",
        "Loading Geographic Data",
        "Vitals: Green",
        "Remaining MP: 100%",
        "Black Box Temperature: Normal",
        "Black Box Internal Pressure: Normal",
        "Activating IFF",
        "Activating FCS",
        "Initializing Pod Connection",
        "Launching DBU Setup",
        "Activating Inertia Control System",
        "Activating Environmental Sensors",
        "Equipment Authentication: Complete",
        "Equipment Status: Green",
        "All Systems Green",
    ]
    property int visibleLinesIndex: 0
    property int currentLine: 0
    property int currentCharacter: 0
    readonly property string authorizationMessage: "AUTHORIZATION REQUIRED: "
    readonly property int authorizationLine: messages.length
    readonly property int lineCount: messages.length + 1
    readonly property bool authorizationRevealed:
      currentLine > authorizationLine
      || (
          currentLine === authorizationLine
          && currentCharacter >= authorizationMessage.length
      )
    property bool animationStarted: false

    function lineAt(index: int): string {
        return index === authorizationLine
            ? authorizationMessage
            : messages[index]
    }

    function startPrinting(): void {
        if (animationStarted)
          return

        animationStarted = true
        printTimer.restart()
    }

    property real warpStrength: 0.01
    property real chromaStrength: 3.25
    property real overscan: 0.015
    property real glitchAmount: 0

    color: "#0b0804"

    layer.enabled: true
    layer.smooth: true
    layer.effect: ShaderEffect {
        property real time: 0
        property real glitchAmount: root.glitchAmount
        property vector2d resolution: Qt.vector2d(root.width, root.height)
        property real warpStrength: root.warpStrength
        property real chromaStrength: root.chromaStrength
        property real overscan: root.overscan

        blending: false
        fragmentShader: Quickshell.shellPath("shaders/yorha-crt.frag.qsb")

        onStatusChanged: {
            if (status === ShaderEffect.Error)
                console.error(`Failed to load lock screen shader: ${log}`)
        }

        NumberAnimation on time {
            from: 0
            to: 1000
            duration: 1000000
            loops: Animation.Infinite
            running: true
        }
    }

    Image {
        anchors.fill: parent
        source: Quickshell.shellPath("assets/bg-tile.png")
        fillMode: Image.Tile
        smooth: false
    }
    
    Image {
        anchors.centerIn: parent
        width: parent.width * 0.5
        height: parent.height * 0.4

        source: Quickshell.shellPath("assets/yorha.png")
        fillMode: Image.PreserveAspectFit
        opacity: 0.1
    }

    RowLayout {
        id: header
        
        anchors {
            top: parent.top
            left: parent.left
            topMargin: parent.height * 0.05
            leftMargin: parent.width * 0.05
        }

        Text {
            text: "LOADING"
            Layout.alignment: Qt.AlignBaseline

            color: "#e5e7e7"
            font.family: "FOT-NewRodin Pro"
            font.pointSize: 48
            font.letterSpacing: 2
        }
        Text {
            text: "- BOOTING SYSTEM.."
            Layout.alignment: Qt.AlignBaseline

            color: "#e5e7e7"
            font.family: "FOT-NewRodin Pro"
            font.pointSize: 24
            font.letterSpacing: 1
        }
    }
    
    ColumnLayout {
        anchors.top: header.bottom
        anchors.left: header.left
        anchors.topMargin: parent.height * 0.04
        anchors.leftMargin: parent.width * 0.02

        spacing: 12

        Repeater {
            model: root.messages

            Text {
                required property int index
                required property string modelData

                readonly property bool printed: index < root.currentLine
                readonly property bool printing: index === root.currentLine

                visible: index <= root.currentLine
                text: {
                    if (printed) return modelData
                    if (printing) return modelData.slice(0, root.currentCharacter) + "_"

                    return ""
                }

                color: "#e5e7e7"
                font.family: "FOT-NewRodin Pro"
                font.pointSize: 16
                font.weight: Font.Bold
                font.letterSpacing: 1
                opacity: 0.8
            }
        }

        RowLayout {
            Text {
                text: {
                    if (!root.animationStarted) return ""

                    if (root.currentLine > root.authorizationLine) return root.authorizationMessage

                    if (root.currentLine === root.authorizationLine) return root.authorizationMessage.slice(0, root.currentCharacter)

                    return ""
                }
                color: "#e5e7e7"
                font.family: "FOT-NewRodin Pro"
                font.pointSize: 16
                font.weight: Font.Bold
                opacity: 0.8
            }

            TextInput {
                Layout.preferredWidth: 300

                color: "#e5e7e7"
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                focus: true
                opacity: root.authorizationRevealed ? 0.8 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 80
                    }
                }

                onTextChanged: root.context.currentText = text
                Keys.onReturnPressed: root.context.tryUnlock()
                Keys.onPressed: event => {
                    root.startPrinting()

                    // Continue into TextInput's normal key processing.
                    event.accepted = false
                }

                cursorDelegate: Item {
                    width: 12

                    Rectangle {
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                            leftMargin: 2
                            bottomMargin: -6
                        }

                        height: 2
                        color: "#e5e7e7"
                    }
                }
            }
        }


        Text {
            visible: root.context.showFailure
            text: "AUTHENTICATION DENIED"
            color: "#e5e7e7"
            font.family: "IBM Plex Sans Condensed"
            font.pointSize: 16
        }
    }

    // Timer {
    //     interval: 120
    //     repeat: true
    //     running: root.visibleLinesIndex < root.messages.length

//         onTriggered: root.visibleLinesIndex++
    // }

    function resetPrinting(): void {
        currentLine = 0
        currentCharacter = 0
        printTimer.restart()
    }

    FrameAnimation {
        id: printTimer

        running: false

        onTriggered: {
            if (root.currentLine >= root.lineCount) {
                stop()
                return
            }

            const message = root.lineAt(root.currentLine)

            if (root.currentCharacter < message.length) {
                root.currentCharacter += 1 + Math.floor(Math.random() * 4)
            } else {
                root.currentLine++
                root.currentCharacter = 0
            }
        }
    }

    Connections {
        target: SleepEvents

        function onResumed() {
            printTimer.running = true
        }
    }

    Timer {
        id: glitchTimer

        running: true
        interval: 900

        onTriggered: {
            root.glitchAmount = 0.45 + Math.random() * 0.55
            glitchEndTimer.interval = 35 + Math.random() * 110
            glitchEndTimer.restart()
        }
    }

    Timer {
        id: glitchEndTimer

        onTriggered: {
            root.glitchAmount = 0

            // Short intervals occasionally produce a cluster of flickers.
            glitchTimer.interval = Math.random() < 0.28
                ? 45 + Math.random() * 130
                : 650 + Math.random() * 2600
            glitchTimer.restart()
        }
    }
}
