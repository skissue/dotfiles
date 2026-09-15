import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: root
    
    property font clockFont: Qt.font({
        family: "PragmataPro",
        pointSize: 14,
        weight: Font.DemiBold
    })

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    HoverHandler {
        id: hover
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

    // TODO this looks horrible, replace with PopupWindow later
    ToolTip {
        visible: hover.hovered
        text: Qt.formatDateTime(clock.date, "dddd, MMMM d, yyyy")
        delay: 500
    }
}
