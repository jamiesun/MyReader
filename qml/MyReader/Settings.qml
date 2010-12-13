import Qt 4.7
import Utils 1.0
Item {
    id:config
   // width: 240;height: 320
    property string email: ""
    property string passwd: ""
    property string feedMax: "100"
    signal finish()

    function doSave(){
        if(email.text==""){ebox.forceActiveFocus();}
        else if(passwd.text==""){pbox.forceActiveFocus();}
        else{
            var fnums = fnum.text?fnum.text:"100"
            utils.write(".config",email.text+","+passwd.text+","+fnums);
            finish();
        }
    }

   Utils{id:utils}

    KeyNavigation.down:ebox

    onFocusChanged: {
        if(activeFocus){
            email.forceActiveFocus()
        }
    }

    Rectangle {
        id: box
        color: "#4b4b4b"
        radius: 8
        anchors.fill: parent
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        anchors.rightMargin: 9
        anchors.leftMargin: 9
        border.color: "#828282"


        Text {
            id: text1
            width: 80
            height: 20
            color: "#ffffff"
            text: "You Email:"
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.pixelSize: 12
        }

        Rectangle {
            id: ebox
            height: 26
            color: email.activeFocus?"#ffffff":"#dbdbdb"
            radius: 5
            anchors.top: text1.bottom
            anchors.topMargin: 5
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
                font.pixelSize: 14
                KeyNavigation.down:passwd;KeyNavigation.up:okbutton
            }
        }

        Text {
            id: text2
            height: 20
            color: "#ffffff"
            text: "You Password:"
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: ebox.bottom
            anchors.topMargin: 8
            font.pixelSize: 12
        }

        Rectangle {
            id: pbox
            height: 26
            color: passwd.activeFocus?"#ffffff":"#dbdbdb"
            radius: 5
            anchors.top: text2.bottom
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            border.color: "#403e3e"
            border.width: passwd.activeFocus?1:0

            TextInput {
                id: passwd;focus: pbox.activeFocus
                text: config.passwd
                echoMode:TextInput.Password
                cursorVisible: activeFocus
                font.pixelSize: 14
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
            font.pixelSize: 12
            anchors.top: pbox.bottom
            anchors.topMargin: 8
            anchors.leftMargin: 20
            anchors.left: parent.left
        }

        Rectangle {
            id: nums
            x: 4
            y: 4
            height: 26
            color: fnum.activeFocus?"#ffffff":"#dbdbdb"
            radius: 5
            anchors.top: text3.bottom
            border.color: "#403e3e"
            anchors.topMargin: 5
            KeyNavigation.up:passwd;KeyNavigation.down:okbutton
            TextInput {
                id: fnum
                text: feedMax
                validator: IntValidator{bottom: 10; top: 1000;}
                cursorVisible: activeFocus
                font.pixelSize: 14
                anchors.fill: parent
                anchors.topMargin: 5
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

        Rectangle {
            id: okbutton;x: 77;
            width: 100;height: 27;radius: 8
            anchors.top: nums.bottom
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: activeFocus?1:0.8
            border.width:activeFocus?1:0; smooth: true
            KeyNavigation.up:fnum;KeyNavigation.down:email
            gradient: Gradient {
                GradientStop {position: 0;color: "#beb4b4"}
                GradientStop { position: 1; color: "#272727"}
            }

            Text {
                id: text4;x: 38;y: 6; color: "#f3f0f0"
                text: "ok";anchors.centerIn: parent
                wrapMode: Text.WordWrap;font.pixelSize: 14
            }
            MouseArea{
                anchors.fill: parent
                onClicked: doSave();
            }

            Keys.onSelectPressed: doSave();
        }
    }
}
