import Qt 4.7
import QtWebKit 1.0
Flickable {
    property string content: ''
    property bool hide: true
    id: flickable
    width: parent.width
    contentWidth: Math.max(parent.width,web_view.width)
    contentHeight: Math.max(parent.height,web_view.height)
    pressDelay: 200
    smooth: true

    signal next()
    signal previous()
    signal back()

    Rectangle{
        anchors.fill: parent
        color: "#ffffff"
        opacity: web_view.opacity
    }

    property int histx : 0
    property int histy : 0

    function resetTbar(){
        tbar.x += contentX-histx
        tbar.y += contentY-histy
        histx = contentX
        histy = contentY
    }
    onContentXChanged: resetTbar()
    onContentYChanged: resetTbar()


    onFocusChanged: {
        if(activeFocus){
            web_view.forceActiveFocus()
        }

    }

    WebView {
        id: web_view
        x: 0;y: 0
        opacity:  hide?0.0:1.0
        clip: true
        preferredWidth: flickable.width
        preferredHeight: flickable.height
        html: content
        settings.javascriptEnabled: true
        settings.pluginsEnabled: true
        settings.localContentCanAccessRemoteUrls: true
        Behavior on opacity{NumberAnimation{duration: 200}}
        Keys.onPressed:{
            if(event.key== 17825792)  flickable.previous()
            else if(event.key== 17825793)  flickable.next()
        }

        Keys.onDigit1Pressed:{
            web_view.contentsScale -= 0.1
        }
        Keys.onDigit3Pressed:{
            web_view.contentsScale += 0.1
        }

        Keys.onDigit5Pressed:tbar.visible = !tbar.visible

        Keys.onUpPressed:{
            if(!flickable.atYBeginning)
                flickable.contentY -= 5;
        }
        Keys.onDownPressed:{
            if(!flickable.atYEnd)
                flickable.contentY += 5;
        }

        Keys.onLeftPressed:{
           if(!flickable.atXBeginning)
                flickable.contentX -= 5;
        }
        Keys.onRightPressed:{
            if(!flickable.atXEnd)
                flickable.contentX += 5;
        }



        Keys.onSelectPressed:flickable.back()


    }

    Rectangle{
        id:tbar
        color: "#ffffff"
        opacity: web_view.opacity-0.1
        width: flickable.parent.width
        height: 32;y:flickable.parent.height-32
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#999999"
            }

            GradientStop {
                position: 1
                color: "#444444"
            }
        }
        Image {
            id: img_previous;x:0;y:0
            source: "pic/previous.png"
            MouseArea{
                scale: 2
                anchors.fill: parent
                onClicked: flickable.previous()
            }
        }
        Image {
            id: img_next;x:tbar.width-32;y:0
            source: "pic/next.png"
            MouseArea{
                scale: 2;x:-3
                anchors.fill: parent
                onClicked: flickable.next()
            }
        }

        Image {
            id: img_back;width: 32;height: 32
            anchors.centerIn: parent
            source: "pic/back.png"
            MouseArea{
                y:-3
                scale: 2
                anchors.fill: parent
                onClicked: flickable.back()
            }
        }

    }
    Lodding{
        id:lodding
        x:0;y:web_view.progress<1?0:-lodding.height
        anchors{leftMargin:0;rightMargin:0}
        Behavior on y{NumberAnimation{duration: 200}}
    }

}
