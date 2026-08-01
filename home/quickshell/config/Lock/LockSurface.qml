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

    color: "#0b0804"

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
}
