import Qt 4.7
import Utils 1.0
Item {
    id:config
   // width: 240;height: 320
    property string email: ""
    property string passwd: ""
    property string feedMax: "30"

    signal finish()
    signal cancel()

    function doSave(){
        if(email.text==""){ebox.forceActiveFocus();}
        else if(passwd.text==""){pbox.forceActiveFocus();}
        else{
            var fnums = fnum.text?fnum.text:"30"
            utils.safeWrite(".config",email.text+","+passwd.text+","+fnums);
            finish();
        }
    }

   Utils{id:utils}

   Keys.onPressed:{
       if(event.key==17825793)cancel()
       else if(event.key==17825792)doSave()
   }

    KeyNavigation.down:ebox

    onFocusChanged: {
        if(activeFocus){
            email.forceActiveFocus()
        }
    }

    Flickable {
        id: box
        anchors.fill: parent
        anchors.bottomMargin: 40


        Text {
            id: text1
            width: 80
            height: 20
            color: "#ffffff"
            text: "Your Email:"
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.pointSize:8
        }

        Rectangle {
            id: ebox
            height: 30
            color: email.activeFocus?"#ffffff":"#dbdbdb"
            radius: 5
            anchors.top: text1.bottom
            anchors.topMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            border.color: "#403e3e"
            border.width: email.activeFocus?1:0

            TextInput {
                id: email
                text: config.email
                cursorVisible: activeFocus
                anchors.rightMargin: 5
                anchors.leftMargin: 5
                anchors.bottomMargin: 5
                anchors.topMargin: 5
                anchors.fill: parent
                font.pointSize:7
                KeyNavigation.down:passwd;KeyNavigation.up:nums
            }
        }

        Text {
            id: text2
            height: 20
            color: "#ffffff"
            text: "Your Password:"
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: ebox.bottom
            anchors.topMargin: 5
            font.pointSize:8
        }

        Rectangle {
            id: pbox
            height: 30
            color: passwd.activeFocus?"#ffffff":"#dbdbdb"
            radius: 5
            anchors.top: text2.bottom
            anchors.topMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            border.color: "#403e3e"
            border.width: passwd.activeFocus?1:0

            TextInput {
                id: passwd;focus: pbox.activeFocus
                text: config.passwd
                echoMode:TextInput.PasswordEchoOnEdit
                cursorVisible: activeFocus
                font.pointSize:7
                anchors.fill: parent
                anchors.topMargin: 5
                anchors.rightMargin: 5
                anchors.bottomMargin: 5
                anchors.leftMargin: 5
                KeyNavigation.up:email;KeyNavigation.down:fnum
            }
        }


        Text {
            id: text3
            x: 4
            y: 4
            height: 20
            color: "#ffffff"
            text: "Feeds maxnum:"
            font.pointSize:8
            anchors.top: pbox.bottom
            anchors.topMargin: 8
            anchors.leftMargin: 20
            anchors.left: parent.left
        }

        Rectangle {
            id: nums
            x: 4
            y: 4
            height: 30
            color: fnum.activeFocus?"#ffffff":"#dbdbdb"
            radius: 5
            anchors.top: text3.bottom
            border.color: "#403e3e"
            anchors.topMargin: 8
            KeyNavigation.up:passwd;KeyNavigation.down:email
            TextInput {
                id: fnum
                text: feedMax
                validator: IntValidator{bottom: 10; top: 1000;}
                cursorVisible: activeFocus
                font.pointSize:7
                anchors.fill: parent
                anchors.topMargin:8
                anchors.rightMargin: 5
                anchors.bottomMargin: 5
                focus: nums.activeFocus
                anchors.leftMargin: 5
            }
            anchors.rightMargin: 20
            border.width: fnum.activeFocus?1:0
            anchors.right: parent.right
            anchors.leftMargin: 20
            anchors.left: parent.left
        }
    }
    Rectangle{
        id:tbar
        color: "#ffffff"
        opacity: 0.8
        width: parent.width
        height: 32;y:parent.height-32
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
            id: imgok;x:0;y:0
            source: "pic/ok.png"
            width:32;height:32
            smooth:true
            MouseArea{
                scale: 2
                anchors.fill: parent
                onClicked: doSave();
            }
        }
        Image {
            id: imgcl;x:tbar.width-32;y:0
            source: "pic/back.png"
            width:32;height:32
            smooth:true
            MouseArea{
                scale: 2;x:-3
                anchors.fill: parent
                onClicked: config.finish()
            }
        }
    }
}
