import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4

import UdpSender 0.0


Window {

    property real mm: (Screen.pixelDensity)

    property int win_width : Qt.platform.os === "android" ? Screen.width : Qt.platform.os === "ios" ? Screen.width : Screen.width*0.5
    property int win_height : Qt.platform.os === "android" ? Screen.height : Qt.platform.os === "ios" ? Screen.height : Screen.height*0.75

    id:root
    visible: true
    width: win_width
    height: win_height

    title: qsTr("Packet Sender")
    color: "#FFFFFF"

    UdpPacketSender{
        id:udpSender

        onCurrentDatagramChanged: {
                viewMessageArea.color = "red"
                console.log("################################## RECEIVED: " + currentDatagram)
                viewMessageArea.text = viewMessageArea.text + currentDatagram + "\n"
        }
    }


    Rectangle{
        id: firstView
        width: root.width
        height: root.height
        color: "#201d41"




    //[FIRST COMPONENT]
        GroupBox {
            id:groupBoxIp
            x: win_width*0.1
            y: win_height*0.075
            antialiasing: true
            title: qsTr("Ip Address")
            clip: false

            Column {
                spacing: 10
                Rectangle{
                    width: win_width*0.8
                    height:win_height*0.08
                    color: "#DC143C"
                    radius: win_height*0.02
                    transformOrigin: Item.Center
                    TextInput {
                        anchors.centerIn: groupBoxIp
                        id: ip_label
                        color: "#F0F0F0"
                        width: win_width*0.8
                        height: win_height*0.08
                        font.italic: true
                        cursorVisible: false
                        opacity: 0.7
                        transformOrigin: Item.Bottom
                        font.pixelSize: win_height*0.04
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        validator: RegExpValidator{regExp:  /^(([1-9]?\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}([1-9]?\d|1\d\d|2[0-5][0-5]|2[0-4]\d)$/}   //  /[0-9]+[.]+/

                        onEditingFinished: {
                            //controllo se tutto corretto, se okay mostro una spunta verde altrimenti x rossa
                            if(!(udpSender.analizeIp(getText(0,15))))
                            {
                                imageCorrectDestIp.visible = true
                                imageErrorDestIp.visible = false
                            }
                            else
                            {
                                imageCorrectDestIp.visible = false
                                imageErrorDestIp.visible = true
                            }
                        }
                    }

                }
            }
        }
    //[END FIRST COMPONENT]
    //[SECOND COMPONENT]
        GroupBox {
            id:groupBoxPort
            title: "Ip Dest Port"
            x: win_width*0.1
            y: win_height*0.275
            clip: false

            Column {
                spacing: 10
                Rectangle{
                    width: win_width*0.8
                    height:win_height*0.08
                    color: "#800000"
                    radius: win_height*0.02
                    transformOrigin: Item.Center
                    TextInput {
                        anchors.centerIn: groupBoxPort
                        id: port_label
                        color: "#F0F0F0"
                        width: win_width*0.8
                        height:win_height*0.08
                        font.italic: true
                        cursorVisible: false
                        opacity: 0.7
                        transformOrigin: Item.Bottom
                        font.pixelSize: win_height*0.04
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        inputMethodHints: Qt.ImhDigitsOnly

                        /*
                            ^                              # anchor match at start-of-line, followed by
                            0*						       # zero or more leading zeros
                            ([1-9])                        # 1 - 9
                            | ([1-9][0-9])                 # 10 - 99
                            | ([1-9][0-9][0-9])            # 100 - 999
                            | ([1-9][0-9][0-9][0-9])	   # 1000 - 9999
                            | ([1-5][0-9][0-9][0-9][0-9])  # 10,000 - 59,999
                            | (6[0-4][0-9][0-9][0-9])      # 60,000 - 64,999
                            | (65[0-4][0-9][0-9])          # 65,000 - 65,499
                            | (655[0-2][0-9])              # 65,500 - 65,529
                            | (6553[0-5])                  # 65,530 - 65,535
                            $
                        */
                        validator: RegExpValidator {regExp:/^(0|[1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$/}    //regExp: /^([1-9]) | ([1-9][0-9]) | ([1-9][0-9][0-9]) | ([1-9][0-9][0-9][0-9]) | ([1-5][0-9][0-9][0-9][0-9]) | (6[0-4][0-9][0-9][0-9]) | (65[0-4][0-9][0-9]) | (655[0-2][0-9]) | (6553[0-5]) $ /}
                        onEditingFinished: {
                            imageCorrectPortDest.visible = true
                            imageErrorPortDest.visible = false
                        }
                    }

                }
            }
        }
    //[END SECOND COMPONENT]
    //[THREE COMPONENT]
        GroupBox {
            id:groupBoxListenPort
            title: "Listen Port"
            x: win_width*0.1
            y: win_height*0.475
            clip: false

            Column {
                spacing: 10
                Rectangle{
                    width: win_width*0.8
                    height:win_height*0.08
                    color: "#800000"
                    radius: win_height*0.02
                    transformOrigin: Item.Center
                    TextInput {
                        anchors.centerIn: groupBoxListenPort
                        id: listen_port_label
                        color: "#F0F0F0"
                        width: win_width*0.8
                        height:win_height*0.08
                        font.italic: true
                        cursorVisible: false
                        opacity: 0.7
                        transformOrigin: Item.Bottom
                        font.pixelSize: win_height*0.04
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        /*
                            ^                              # anchor match at start-of-line, followed by
                            0*						       # zero or more leading zeros
                            ([1-9])                        # 1 - 9
                            | ([1-9][0-9])                 # 10 - 99
                            | ([1-9][0-9][0-9])            # 100 - 999
                            | ([1-9][0-9][0-9][0-9])	   # 1000 - 9999
                            | ([1-5][0-9][0-9][0-9][0-9])  # 10,000 - 59,999
                            | (6[0-4][0-9][0-9][0-9])      # 60,000 - 64,999
                            | (65[0-4][0-9][0-9])          # 65,000 - 65,499
                            | (655[0-2][0-9])              # 65,500 - 65,529
                            | (6553[0-5])                  # 65,530 - 65,535
                            $
                        */
                        validator: RegExpValidator {regExp:/^(0|[1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$/}    //regExp: /^([1-9]) | ([1-9][0-9]) | ([1-9][0-9][0-9]) | ([1-9][0-9][0-9][0-9]) | ([1-5][0-9][0-9][0-9][0-9]) | (6[0-4][0-9][0-9][0-9]) | (65[0-4][0-9][0-9]) | (655[0-2][0-9]) | (6553[0-5]) $ /}
                        inputMethodHints: Qt.ImhDigitsOnly
                        onEditingFinished: {
                            imageCorrectPortSrc.visible = true
                            imageErrorPortSrc.visible = false
                        }
                    }

                }
            }
        }
    //[END THREE COMPONENT]
    //[FOUR COMPONENT]
            GroupBox {
                id:groupBoxMyIp
                x: win_width*0.1
                y: win_height*0.675
                antialiasing: true
                title: qsTr("My Ip Address")
                clip: false


                Column {
                    spacing: 10
                    Rectangle{
                        width: win_width*0.8
                        height:win_height*0.08
                        color: "#FFFF00"
                        radius: win_height*0.02
                        border.color: "#FFFF00"
                        clip: false
                        transformOrigin: Item.Center

                        Text {
                            id: myIp
                            text: udpSender.viewAllAddress()
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            padding: 0
                            font.capitalization: Font.SmallCaps
                            font.italic: true
                            transformOrigin: Item.Center
                            anchors.fill: parent
                            font.pixelSize:win_height*0.04
                            anchors.centerIn: groupBoxMyIp

                        }
                    }
                }
            }

    //[END FOUR COMPONENT]
    //[FIVE COMPONENT]
            Rectangle {
                id: startButton
                x: win_width*0.115
                y: win_height*0.875
                width: win_width*0.8
                height:win_height*0.08
                color: "#00FF00"
                radius: win_height*0.02
                Text {
                    text: qsTr("Start")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill:parent
                }
                    MouseArea{
                        anchors.fill:parent

                    onClicked: {

                        //CLICK MOUSE

                        if(listen_port_label.text != "")
                        {
                            if(port_label.text != "")
                            {
                                if(!(udpSender.analizeIp(ip_label.getText(0,15))))
                                {
                                    //METTERE CHE QUANDO PREMO START SCORRESCHERMATA FUORI E COMPARE UNA NUOVAS CON SOLO MESSAGE E SENDER
                                    firstViewFadeOut.start()
                                    secondViewFadeIn.start()
                                    secondView.visible = true
                                    udpSender.initPacket(ip_label.getText(0,15),myIp.text,port_label.getText(0,5),listen_port_label.getText(0,15))

                                }
                                else
                                {
                                    imageCorrectDestIp.visible = false
                                    imageErrorDestIp.visible = true
                                }
                            }
                            else
                            {
                                imageCorrectPortDest.visible = false
                                imageErrorPortDest.visible = true
                                //aggiungere immagine errore
                            }
                        }
                        else
                        {
                            imageCorrectPortSrc.visible = false
                            imageErrorPortSrc.visible = true
                            //aggiungere immagine errore
                        }


                    }
                }


            }
    //[END FIVE COMPONENT]

        transformOrigin: Item.TopLeft


        NumberAnimation on x {
            id: firstViewFadeOut
            easing.type: Easing.OutBack
            to: - firstView.width
            from: 0
            duration: 1500
            }
        NumberAnimation on x {
            id: firstViewFadeIn
            easing.type: Easing.OutBack
            to:  0
            from: - firstView.width
            duration: 1500
        }

        Component.onCompleted: {
            firstViewFadeIn.stop()
            firstViewFadeOut.stop()
            secondViewFadeIn.stop()
            secondViewFadeOut.stop()
        }

        Image {
            id: imageCorrectDestIp
            source:  encodeURIComponent("/pics/GreenArrow.png")
            width: groupBoxIp.height
            height:groupBoxIp.height
            anchors.left: groupBoxIp.left
            anchors.leftMargin: win_width*0.03
            visible: false
            anchors.top: groupBoxIp.top
            anchors.topMargin: groupBoxIp.height/7

        }
        Image {
            id: imageErrorDestIp
            source:  encodeURIComponent("/pics/Error_3.png")
            width: groupBoxIp.height
            height:groupBoxIp.height
            anchors.left: groupBoxIp.left
            anchors.leftMargin: win_width*0.03
            visible: false
            anchors.top: groupBoxIp.top
            anchors.topMargin: groupBoxIp.height/7

        }


        Image {
            id: imageCorrectPortDest
            source:  encodeURIComponent("/pics/GreenArrow.png")
            width: groupBoxPort.height
            height:groupBoxPort.height
            anchors.left: groupBoxPort.left
            anchors.leftMargin: win_width*0.03
            visible: false
            anchors.top: groupBoxPort.top
            anchors.topMargin: groupBoxPort.height/7

        }
        Image {
            id: imageErrorPortDest
            source:  encodeURIComponent("/pics/Error_3.png")
            width: groupBoxPort.height
            height:groupBoxPort.height
            anchors.left: groupBoxPort.left
            anchors.leftMargin: win_width*0.03
            visible: false
            anchors.top: groupBoxPort.top
            anchors.topMargin: groupBoxPort.height/7
        }

        Image {
            id: imageCorrectPortSrc
            source:  encodeURIComponent("/pics/GreenArrow.png")
            width: groupBoxListenPort.height
            height:groupBoxListenPort.height
            anchors.left: groupBoxListenPort.left
            anchors.leftMargin: win_width*0.03
            visible: false
            anchors.top: groupBoxListenPort.top
            anchors.topMargin: groupBoxListenPort.height/7

        }
        Image {
            id: imageErrorPortSrc
            width: groupBoxListenPort.height
            height:groupBoxListenPort.height
            anchors.left: groupBoxListenPort.left
            anchors.leftMargin: win_width*0.03
            visible: false
            anchors.top: groupBoxListenPort.top
            anchors.topMargin: groupBoxListenPort.height/7
        }


    }//[END OF FIRST VIEW]


    //[START OF SECOND VIEW]

    Rectangle {
        id: secondView
        width: root.width
        height: root.height
        color: "#201d41"
        visible: false
        TextArea{
            id: viewMessageArea
            width: secondView.width - (win_width*0.01)
            anchors.top: parent.top
            anchors.topMargin: win_height*0.005
            anchors.left: parent.left
            anchors.leftMargin: win_height*0.005
            height: (win_height*0.75)
            readOnly: true
            placeholderText: qsTr("Message...")

            background: Rectangle {
                border.color:"#21be2b"
                color: "#083045"
            }
        }

        TextArea{
            id: messageArea
            width: root.width - (win_width*0.025)
            anchors.top: viewMessageArea.bottom
            anchors.left: secondView.left
            anchors.leftMargin:win_width*0.05
            anchors.bottomMargin:win_height*0.05
            height:win_height*0.15
            wrapMode: TextEdit.WrapAnywhere
            placeholderText: qsTr(" !! Write Here !!")
        }

        Image {
            id: imageSend
            source:  encodeURIComponent("/pics/send.png")
            width: win_width*0.15
            height: win_width*0.15
            transformOrigin: Item.TopLeft
            visible: true
            y:messageArea.y +  win_width*0.02
            x: messageArea.x + messageArea.width - win_width*0.17

            MouseArea{
                anchors.fill: imageSend
                onClicked: {

                    //SEND PACKET AND SEND TO VIEWMESSAGEAREA
                    viewMessageArea.color = "#fff44f"
                    messageArea.insert(messageArea.cursorPosition, " ")
                    messageArea.cursorPosition
                    console.log("################ LUNGHEZZA : " + messageArea.text.length)
                    udpSender.sendPacket(messageArea.getText(0,messageArea.text.length))
                    viewMessageArea.text = viewMessageArea.text + messageArea.getText(0,messageArea.text.length + "\n")   //("<p style='color: " + "#fff44f" +  ";'>" + messageArea.getText(0,messageArea.text.length) +  "</p>")
                    console.log(viewMessageArea.text)
                    messageArea.remove(0,messageArea.text.length)
                }
            }

        }

        NumberAnimation on x {
            id: secondViewFadeOut
            easing.type: Easing.OutBack
            from:0
            to: secondView.width
            duration: 1500
            }
        NumberAnimation on x {
            id: secondViewFadeIn
            easing.type: Easing.OutBack
            from:secondView.width
            to: 0
            duration: 1500
        }

        Component.onCompleted: {
            firstViewFadeIn.stop()
            firstViewFadeOut.stop()
            secondViewFadeIn.stop()
            secondViewFadeOut.stop()
            secondView.visible = false

            darkModeON()
        }

    }//[END OF SECOND VIEW]


    function darkModeON()
    {
        groupBoxIp.title = "<font color=\"white\">Ip Address</font>";
        groupBoxPort.title = "<font color=\"white\">Ip Dest Port</font>";
        groupBoxListenPort.title = "<font color=\"white\">Listen Port</font>";
        groupBoxMyIp.title = "<font color=\"white\">My Ip Address</font>";
        firstView.color = "#0a0a0a"
        secondView.color = "#0a0a0a"
    }
    function darkModeOFF()
    {
        groupBoxIp.title = "<font color=\"black\">Ip Address</font>";
        groupBoxPort.title = "<font color=\"black\">Ip Dest Port</font>";
        groupBoxListenPort.title = "<font color=\"black\">Listen Port</font>";
        groupBoxMyIp.title = "<font color=\"black\">My Ip Address</font>";
        firstView.color = "#FFFFF0"
        secondView.color = "#FFFFF0"
    }

}
