import Qt 4.7
import Utils 1.0
Rectangle {
    id: main
    width: 800
    height: 600
//    anchors{leftMargin:0;rightMargin:0;topMargin:0;bottomMargin:0}
    property string email: ""
    property string passwd: ""
    property string auth: ''
    property string sid: ''
    property string feedMax: "100"
    focus: true

    Keys.onPressed:{
        console.log("key is "+event.key)
        if(event.key==17825797){

        }
    }


    Utils{id:utils}

    WorkerScript {
        id: authWork
        source: "auth.js"
        onMessage: {
            if(messageObject.auth&&messageObject.sid){
                console.log("login success")
                auth = messageObject.auth;
                sid = messageObject.sid;
            }
            else{
                console.log("login faild");
                alert.show("login failure");
            }

        }
    }

    gradient: Gradient {
        GradientStop {id: gradientstop1;position: 0;color: "#515151"}
        GradientStop {id: gradientstop2; position: 1;color: "#000000"}
    }


    function initConfig(){
        var cfgstr = utils.safeRead(".config")
        if(cfgstr == ""){
            main.state = "settings"
        }else{
            var cfgs = cfgstr.split(",")
            main.email = cfgs[0]
            main.passwd = cfgs[1]
            main.feedMax = cfgs[2]?cfgs[2]:"100"
            authWork.sendMessage({email:main.email,passwd:main.passwd});
            console.log(main.email);
        }
    }

    Component.onCompleted:initConfig()



    Menu{
        id:menulist;focus: true
        width:main.width;height:main.height;x:0;y:0
        Behavior on x{NumberAnimation{duration: 200}}
        Behavior on opacity{NumberAnimation{duration: 200}}

        Keys.onPressed: {
            if(event.key==17825793){
                main.state="quit"
            }
        }

        function showLev0(source){
            main.state = "showFeeds"
            itemFeeds.history = ""
            itemFeeds.update(source)
        }
        function showLev1(source){
            main.state = "showFeeds"
            itemFeeds.history = source
            itemFeeds.update(source)
        }

        onDoAllitems: showLev0(source)

        onDoFollows: showLev0(source)

        onDoSubscriptions: showLev1(source)

        onDoTags:showLev1(source)

        onDoStarred: showLev0(source)

        onDoNotes: showLev0(source)

        onDoSettings: {
            main.state = "settings"
        }
        onDoAbout:main.state = "about"

        onQuit: Qt.quit()
    }

    Settings{
        id:settings
        width:main.width;height:main.height;x:main.width;y:0
        Behavior on x{NumberAnimation{duration: 200}}
        onFinish: {
            initConfig();
            main.state = "showMenu";
        }
        onCancel:main.state = "showMenu";
    }

    FeedList {
        id: itemFeeds
        property string  history: ""
        auth: main.auth
        sid: main.sid
        feedMax: main.feedMax
        width:main.width;height:main.height;x:main.width;y:0
        Behavior on x{NumberAnimation{duration: 200}}

        function doBack(){
            if(history){
                update(history);
                history = "";
            }else{
                main.state = "showMenu";
            }
        }

        Keys.onPressed: {
            if(event.key==17825793){
                main.state="showMenu"
            }
        }

        Keys.onLeftPressed:doBack()
        onBack: doBack()
        onItemClick: {
            feedDetail.content = content
            main.state = "showItem"
        }
        onLoginTimeout: {
            authWork.sendMessage({email:main.email,passwd:main.passwd});
        }
        onError: alert.show(msg)
    }

    FeedDetail{
        id:feedDetail
        hide:main.state!="showItem"
        width:main.width;height:main.height;x:main.width;y:0
        Behavior on x{NumberAnimation{duration: 200}}
        onPrevious: content = itemFeeds.previous()
        onNext: content = itemFeeds.next()
        onBack: main.state = "showFeeds";

    }

    QuitBar{
        id:quitBox;width: parent.width
        Keys.onPressed: {
            if(event.key==16777219||event.key==17825793){
                main.state="showMenu"
            }
            else if(event.key==17825792){
                Qt.quit();
            }
        }
    }

    About{
        id:about
        width:main.width;height:main.height;x:main.width;y:0
        Behavior on x{NumberAnimation{duration: 200}}
        onClick:main.state = "showMenu"
    }

    states: [
        State {name: "showMenu";PropertyChanges {target: menulist;focus:true}},
        State {
            name: "settings"
            PropertyChanges {target: menulist;x: -main.width}
            PropertyChanges { target: settings;x: 0;focus:true;email:main.email;passwd:main.passwd;feedMax:main.feedMax}
        },
        State {
            name: "showFeeds"
            PropertyChanges {target: menulist;x: -main.width}
            PropertyChanges {target: itemFeeds;x: 0;focus:true}
        },
        State {
            name: "showItem"
            PropertyChanges {target: itemFeeds;x: -main.width}
            PropertyChanges {target: feedDetail;x: 0;focus: true}
        },
        State {
            name: "about"
            PropertyChanges {target: menulist;x: -main.width}
            PropertyChanges { target: about;x: 0;focus:true}
        },
        State {
            name: "quit"
            PropertyChanges {target: quitBox;y: parent.height-30;focus:true}
            PropertyChanges {target: menulist;opacity: 0.24}
        }

    ]

    Alert{id:alert;anchors.centerIn: main}
}
