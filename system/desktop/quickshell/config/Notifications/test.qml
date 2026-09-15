import Quickshell
import QtQuick.Layouts

ShellRoot {
    FloatingWindow {
        implicitWidth: cards.implicitWidth + 80
        implicitHeight: cards.implicitHeight + 80
        color: "#171716"

        ColumnLayout {
            id: cards

            anchors.centerIn: parent
            spacing: NotificationStyle.toastSpacing

            TransmissionCard {
                title: "YoRHa Test Suite"
                summary: "Transmission received"
                body: "Visual notification scaffold initialized. All systems nominal."
            }

            TransmissionCard {
                title: "Pod 042"
                summary: "System report"
                body: "Secondary notification channel online. No anomalies detected."
            }
        }
    }
}
