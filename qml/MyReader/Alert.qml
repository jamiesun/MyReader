import Qt 4.7

Item{
    property string message: ""
    id:alert
    width: 210
    height: 60
    opacity: 0.0
    Behavior on opacity{NumberAnimation{duration: 200}}
    function show(msg){
        alert.message = msg
        alert.opacity = 1.0
        timer.start()
    }

    function hide(){
        alert.opacity = 0.0
    }

    Timer{
        id:timer
        interval: 2200; running: false; repeat: false
        onTriggered: hide()
    }


    Rectangle {
        id: rectangle1
        radius: 9
        border.width: 2
        gradient: Gradient {
            GradientStop {
                position: 0.01
                color: "#a2a0a0"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
        border.color: "#ececec"
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5
        anchors.topMargin: 5
        opacity: 0.8
        anchors.fill: parent

        TextEdit {
            id: text_edit1
            color: "#eee7e7"
            text: message
            font.bold: false
            anchors.rightMargin: 12
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10
            anchors.fill: parent
            font.pixelSize: 13
        }

    }

}


