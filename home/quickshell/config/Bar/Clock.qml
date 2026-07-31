import Quickshell
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    property font clockFont: Qt.font({
        family: "PragmataPro",
        pointSize: 14,
        weight: Font.DemiBold
    })
    
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        color: "#cecece"
        font: clockFont
        text: Qt.formatDateTime(clock.date, "hh")
    }

    Text {
        color: "#cd974b"
        font: clockFont
        text: Qt.formatDateTime(clock.date, "mm")
    }


    Text {
        color: "#cecece"
        font.family: clockFont.family
        font.pointSize: clockFont.pointSize
        text: Qt.formatDateTime(clock.date, "ss")
    }
}
