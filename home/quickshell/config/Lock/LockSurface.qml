pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

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
        fragmentShader: Qt.resolvedUrl("Shaders/yorha-crt.frag.qsb")

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
        source: Qt.resolvedUrl("bg-tile.png")
        fillMode: Image.Tile
        smooth: false
    }
    
    Image {
        anchors.centerIn: parent
        width: parent.width * 0.5
        height: parent.height * 0.4

        source: Qt.resolvedUrl("yorha.png")
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
            font.family: "IBM Plex Sans Condensed"
            font.pointSize: 48
            font.letterSpacing: 2
        }
        Text {
            text: "- BOOTING SYSTEM.."
            Layout.alignment: Qt.AlignBaseline

            color: "#e5e7e7"
            font.family: "IBM Plex Sans Condensed"
            font.pointSize: 24
            font.letterSpacing: 1
        }
    }
    
    ColumnLayout {
        anchors.top: header.bottom
        anchors.left: header.left
        anchors.topMargin: parent.height * 0.05
        anchors.leftMargin: parent.width * 0.02

        spacing: 16

        Repeater {
            model: root.messages

            Text {
                required property string modelData
                text: modelData

                color: "#e5e7e7"
                font.family: "IBM Plex Sans Condensed"
                font.pointSize: 16
                font.weight: Font.Bold
                font.letterSpacing: 1
                opacity: 0.8
            }
        }

        RowLayout {
            Text {
                text: "AUTHORIZATION REQUIRED: "
                color: "#e5e7e7"
                font.family: "IBM Plex Sans Condensed"
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

                onTextChanged: root.context.currentText = text
                Keys.onReturnPressed: root.context.tryUnlock()
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
