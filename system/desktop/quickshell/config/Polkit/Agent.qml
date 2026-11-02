import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Polkit
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: root

    PolkitAgent {
        id: agent

        onIsRegisteredChanged: console.log(`ready: ${isRegistered}`)
    }

    property var flow: agent.flow

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    visible: agent.isActive
    focusable: true

    implicitWidth: 400

    Shortcut {
        sequence: "Escape"
        context: Qt.WindowShortcut
        enabled: root.visible
        onActivated: flow?.cancelAuthenticationRequest()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8

        Text {
            text: flow?.message ?? ""
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }

        Text {
            text: flow?.supplementaryMessage ?? ""
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }

        Text {
            text: flow?.inputPrompt ?? ""
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }

        TextField {
            focus: true
            echoMode: flow?.responseVisible ? TextInput.Normal : TextInput.Password
            onAccepted: flow.submit(text)
            Layout.fillWidth: true
        }
    }
}
