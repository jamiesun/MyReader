import Qt 4.7

FocusScope {
    id: menu
    //width: 320;height: 240
    signal doAllitems(string source)
    signal doFollows(string source)
    signal doSubscriptions(string source)
    signal doTags(string source)
    signal doStarred(string source)
    signal doNotes(string source)
    signal doSettings()
    signal quit()


    function doAction(itext,source){
        if(itext=="All items"){doAllitems(source)}
        else if(itext=="You follows"){doFollows(source)}
        else if(itext=="Subscriptions"){doSubscriptions(source)}
        else if(itext=="All tags"){doTags(source)}
        else if(itext=="Starred items"){doStarred(source)}
        else if(itext=="All notes"){doNotes(source)}
        else if(itext=="settings"){doSettings()}
    }

    onFocusChanged: {
        if(activeFocus){
            list_menu.forceActiveFocus()
        }
    }

    Keys.onDigit5Pressed:tbar.visible = !tbar.visible


    ListModel{
        id:menuModel
        ListElement{
            name:"All items"
            icon:"pic/alls.png"
            src:"https://www.google.com/reader/atom/user/-/state/com.google/reading-list"
        }
        ListElement{
            name:"You follows"
            icon:"pic/follows.png"
            src:"https://www.google.com/reader/atom/user/-/state/com.google/broadcast-friends"
        }
        ListElement{
            name:"Subscriptions"
            icon:"pic/subs.png"
            src:"http://www.google.com/reader/api/0/subscription/list"
        }
        ListElement{
            name:"All tags"
            icon:"pic/tags.png"
            src:"http://www.google.com/reader/api/0/tag/list"
        }
        ListElement{
            name:"Starred items"
            icon:"pic/star.png"
            src:"https://www.google.com/reader/atom/user/-/state/com.google/starred"
        }
        ListElement{
            name:"All notes"
            icon:"pic/notes.png"
            src:"https://www.google.com/reader/atom/user/-/state/com.google/created"
        }
        ListElement{
            name:"settings"
            icon:"pic/settings.png"
            src:""
        }
    }

    Component {
        id: highlight
        Rectangle {
            color: "dimgray"; radius: 5
            width: list_menu.width
            Behavior on x { SpringAnimation { spring: 3; damping: 0.2 } }
            Behavior on y { SpringAnimation { spring: 3; damping: 0.2 } }
        }
    }

    ListView {
        id: list_menu
        clip: true
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: tbar.visible?35:10
        anchors.topMargin: 10
        anchors.fill: parent
        keyNavigationWraps: true
        model: menuModel
        highlight: highlight
        spacing: 5
        delegate: Item{
            id:mitem
            width: list_menu.width
            height: 48
            property string it_source: src
            property string it_name: name
            Rectangle {
                id: item;radius:5; opacity: 0.3
                anchors.fill:parent
            }

            Image {
                source: icon
                width: 32;height: 32
                x:5;y:9
            }

            Text {
                id:text_it;width: parent.width-40;color: "#ffffff";text: it_name
                smooth: true;font.pointSize: 10
                anchors{left: parent.left;leftMargin: 40;verticalCenter: parent.verticalCenter}

            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: doAction(mitem.it_name,mitem.it_source)
                onEntered:{
                    list_menu.currentIndex = index
                    list_menu.forceActiveFocus()
                }
            }


            Keys.onSelectPressed:doAction(mitem.it_name,mitem.it_source)


        }
    }

    Rectangle{
        id:tbar
        opacity:0.8
        width: parent.width
        height: 32;
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
        y:parent.height-32
        anchors.top: list_menu.bottom
        anchors.topMargin: 3


        Image {
            id: img_back;width: 32;height: 32; opacity: 1;x: parent.width-32
            source: "pic/exit.png"
            MouseArea{
                id:bmouse
                y:-3
                scale: 2
                anchors.fill: parent
                onClicked:menu.quit()
            }
        }

    }


}
