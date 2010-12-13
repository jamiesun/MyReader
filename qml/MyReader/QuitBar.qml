import Qt 4.7

Rectangle {
    id: quitBox
    y: parent.height
    width: 320
    height: 25
    radius: 5
    anchors.right: parent.right
    anchors.rightMargin: 5
    anchors.left: parent.left
    anchors.leftMargin: 5
    Behavior on y{NumberAnimation{duration: 200}}
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#555555"
        }

        GradientStop {
            position: 1
            color: "#000000"
        }
    }

    Text {
        id: text1
        color: "#ffffff"
        text: "Are you quit?"
        anchors.centerIn: parent
        font.pixelSize: 12
    }

    Text {
        id: text2
        color: "#f9f9f9"
        text: "yes"
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 12
    }

    Text {
        id: text3
        color: "#f9f9f9"
        text: "no"
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 12
    }
}
