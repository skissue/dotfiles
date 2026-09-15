import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property real progress
    readonly property real strokeWidth: 3
    readonly property real inset: strokeWidth / 2

    anchors.fill: parent

    ShapePath {

        strokeWidth: root.strokeWidth
        strokeColor: "#ded8c8"
        fillColor: "transparent"
        capStyle: ShapePath.FlatCap
        joinStyle: ShapePath.MiterJoin

        trim.start: 0
        trim.end: Math.max(0, Math.min(1, root.progress))

        // Begin at 12 o'clock and proceed clockwise.
        startX: root.width / 2
        startY: root.inset

        PathLine {
            x: root.width - root.inset
            y: root.inset
        }

        PathLine {
            x: root.width - root.inset
            y: root.height - root.inset
        }

        PathLine {
            x: root.inset
            y: root.height - root.inset
        }

        PathLine {
            x: root.inset
            y: root.inset
        }

        PathLine {
            x: root.width / 2
            y: root.inset
        }
    }
}
