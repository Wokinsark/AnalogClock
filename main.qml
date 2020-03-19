import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.0
import QtCharts 2.3

ApplicationWindow {
         id: gui
    visible: true
      width: 640
     height: 480
      title: qsTr("Часики")

    property int      x: gui.width / 2
    property int      y: gui.height / 2
    property int rotate: 0
    property int length: 100

    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
    }

    Canvas {
        id: drawingCanvas
        anchors.fill: parent
        function draw(lines) {
            var ctx = getContext("2d")
            ctx.reset();

            for (var i in lines) {
                var line = lines[i];
                ctx.strokeStyle = line.color || Qt.rgba(0, 0, 0, 1);
                ctx.lineWidth   = line.width || 3;
                ctx.beginPath();
                ctx.moveTo(line.x1, line.y1); //start point
                ctx.lineTo(line.x2, line.y2);
                ctx.stroke();
            }

            drawingCanvas.requestPaint();
        }
    }

    Action {
        shortcut: "Esc"
        onTriggered: close()
    }

    Timer {
        interval: 50
        running: true
        repeat: true
        onTriggered: {
            calc(gui.x, gui.y, gui.length);
        }
        function calc(x, y, length) {
            var time     = new Date();
            var hour     = time.getHours() % 12;
            var minutes  = time.getMinutes();
            var seconds  = time.getSeconds();
            var millisec = time.getMilliseconds();
            var lines    = [];
            lines.push({
                           x1: x,
                           y1: y,
                           x2: x - Math.sin((hour * 30 + (minutes / 60 * 30) + 180) / 180 * Math.PI)  * (length - 40),
                           y2: y + Math.cos((hour * 30 + (minutes / 60 * 30) + 180) / 180 * Math.PI)  * (length - 40),
                           color: "red"
                       });
            lines.push({
                           x1: x,
                           y1: y,
                           x2: x - Math.sin((minutes * 6 + (seconds / 60 * 6) + 180) / 180 * Math.PI)  * length,
                           y2: y + Math.cos((minutes * 6 + (seconds / 60 * 6) + 180) / 180 * Math.PI)  * length,
                           color: "blue"
                       });
            lines.push({
                           x1: x,
                           y1: y,
                           x2: x - Math.sin((seconds * 6 + (millisec / 1000 * 6) + 180) / 180 * Math.PI)  * (length),
                           y2: y + Math.cos((seconds * 6 + (millisec / 1000 * 6) + 180) / 180 * Math.PI)  * (length),
                           color: "gray"
                       });
            drawingCanvas.draw(lines);
        }
    }
}
