import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property LockContext context

    color: "#222222"

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatTime(new Date(), "hh:mm")
            color: "#eeeeee"
            font.pixelSize: 72
        }

        TextInput {
            Layout.preferredWidth: 300

            color: "#eeeeee"
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            focus: true

            onTextChanged: root.context.currentText = text
            Keys.onReturnPressed: root.context.tryUnlock()
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            visible: root.context.showFailure
            text: "Authentication failed"
            color: "#cc8888"
        }
    }
}
