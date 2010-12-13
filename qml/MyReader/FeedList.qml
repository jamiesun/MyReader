import Qt 4.7

FocusScope {
    id: feedlist
    property string auth: ''
    property string sid: ''
    signal itemClick(string content)
    signal loginTimeout()
    signal error(string msg)
    signal back()
    property bool isLoadding: false

    onFocusChanged: {
        if(activeFocus){
            feed_list.forceActiveFocus()
        }
    }

    WorkerScript {
        id: feedWork
        source: "feedUpdate.js"
        onMessage: {
            if(messageObject.error){
                console.log("update feed error:"+messageObject.error);
                error("update error:"+messageObject.error)
            }else if(messageObject.timeout){
                console.log("logn timeout");
                error("auth timeout")
                loginTimeout();
            }
            isLoadding = false;
        }
    }

    function update(src){
        console.log("update "+src)
        feedWork.sendMessage({source:src,model:feedModel,auth:auth,sid:sid})
        isLoadding = true;
    }

    function previous(){
        feed_list.decrementCurrentIndex();
        return feed_list.currentItem.ctx;
    }
    function next(){
        feed_list.incrementCurrentIndex();
        return feed_list.currentItem.ctx;
    }

    Keys.onDigit5Pressed:tbar.visible = !tbar.visible


    ListModel { id: feedModel }

    Component {
        id: highlight
        Rectangle {
            color: "dimgray"; radius: 5
            //anchors.fill: feed_list.currentItem
            Behavior on x { SpringAnimation { spring: 3; damping: 0.2 } }
            Behavior on y { SpringAnimation { spring: 3; damping: 0.2 } }
        }
    }

    ListView {
        id: feed_list
        clip: true
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: tbar.visible?35:10
        anchors.topMargin: 10
        anchors.fill: parent
        model: feedModel
        highlight: highlight
        spacing:5
        delegate: FeedItem{
            id:feeditem
            function action(){
                if(feeditem.source){
                    feedlist.update(feeditem.source);
                }else if(feeditem.ctx){
                    feedlist.itemClick(feeditem.ctx)
                }
            }

            Keys.onSelectPressed:action()
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: action()
                onEntered:{
                    feed_list.currentIndex = index
                    feed_list.forceActiveFocus()
                }
            }

        }
    }

    Rectangle{
        id:tbar
        opacity:0.7
        width: parent.width
        height: 32; gradient: Gradient {
            GradientStop {
                position: 0
                color: "#999999"
            }

            GradientStop {
                position: 1
                color: "#444444"
            }
        }
        y:parent.height-32
        anchors.top: feed_list.bottom
        anchors.topMargin: 3


        Image {
            id: img_back;width: 32;height: 32; opacity: 1;x: parent.width-32
            source: "pic/back.png"
            MouseArea{
                id:bmouse
                y:-3
                scale: 2
                anchors.fill: parent
                onClicked: feedlist.back()
            }
        }

    }

    Lodding{
        id:lodding
        x:0;y:isLoadding?0:-lodding.height
        anchors{leftMargin:0;rightMargin:0}
        Behavior on y{NumberAnimation{duration: 200}}
    }


}
