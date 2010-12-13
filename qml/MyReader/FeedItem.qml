import Qt 4.7

FocusScope{
    id: focusscope1
    width: parent.width
    height: text.height+20
    property string desc: from?"<b>"+from+":</b> "+title:title
    property string ctx: content
    property string source: link
    Rectangle {
        id: itembox
        radius: 5
        anchors.fill: parent
        opacity: 0.3
    }

    TextEdit {
        id:text
        width: parent.width-20
        color: "#ffffff"
        text: desc
        anchors.centerIn: parent
        readOnly: true
        textFormat: TextEdit.RichText
        wrapMode: TextEdit.WordWrap
        smooth: true
        font.pointSize:8
    }
}

