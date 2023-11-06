import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.5
import "../components"

Popup {
    id: newHotelPop
    modal: true
    focus: true
    padding: 0
    width: 540
    height: 440
    background: Rectangle {
        color: "transparent"
        radius: 15
    }
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    contentItem: Rectangle{
        color: "transparent"
        radius: 15
        Drag.active: true
        MouseArea{
            anchors.fill: parent
            drag.target: parent
        }

        Rectangle {
            id: display1
            radius: 15

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "silver"
                }
                GradientStop {
                    position: 1.0
                    color: "slategray"
                }
            }

            border.width: 1
            border.color: "paleturquoise"

            anchors {
                fill: parent
            }

            Rectangle {
                id: topBar
                // radius: 15
                height: 30
                color: "transparent"

                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();

                        var centreX = width / 2;
                        var centreY = height / 2;

                        ctx.beginPath();
                        ctx.fillStyle =  Qt.lighter("blue");
                        ctx.moveTo(centreY, centreY);
                        ctx.arc(centreY, centreY, centreY, -Math.PI, -Math.PI* 0.5, false);
                        ctx.lineTo(centreY, 0);
                        ctx.lineTo(width-centreY, 0);
                        ctx.lineTo(width-centreY, centreY);
                        ctx.arc(width-centreY, centreY, centreY, -Math.PI* 0.5, 0, false);
                        ctx.lineTo(width, height);
                        ctx.lineTo(0, height);
                        ctx.lineTo(0, centreY);
                        ctx.fill();
                        ctx.closePath();
                    }
                }
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                Image {
                    id: topBarIcon
                    width: 16
                    height: 16
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 5
                    }
                    source: "../images/svg_images/user_icon.svg"
                }

                Label {
                    id: topBarTitle
                    width: 40
                    height: 16
                    text: "添加酒店"
                    anchors {
                        left: topBarIcon.right
                        leftMargin: 5
                        verticalCenter: parent.verticalCenter
                    }
                    font.bold: true
                    font.pointSize: 12
                    color: "white"
                }

                TopBarButton {
                    id: btnClose
                    width: 30
                    height: 30
                    btnColorDefault: "transparent"
                    btnColorClicked: "#ff007f"
                    btnIconSource: "../images/svg_images/close_icon.svg"

                    anchors {
                        top: parent.top
                        right: parent.right
                    }
                    onClicked: newHotelPop.close()
                }
            }

            Rectangle {
                id: hotelNameEdit
                width: 350
                height: 35
                color: "transparent"

                anchors {
                    top: topBar.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }

                Row {
                    spacing: 10

                    Label {
                        id: hotelNameLabel
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }
                            font.bold:          true
                            font.pointSize:     10
                            text:               "酒店名称:"
                        }
                    }
                    
                    TextField {
                        id: hotelNameInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: hotelNameInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: hotelNameInput.enabled ? "white": "transparent"
                            property alias borderColor: hotelNameInputBg.border.color
                            border {
                                color: hotelNameInput.focus ? "#21be2b": "transparent"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                }
            }

            Rectangle {
                id: addrEdit
                width: 350
                height: 35
                color: "transparent"

                anchors {
                    top: hotelNameEdit.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
                Row {
                    spacing: 10

                    Label {
                        id: addrLabel
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }             
                            font.bold:          true
                            font.pointSize:     10
                            text:               "酒店地址:"
                        }
                    }

                    TextField {
                        id: addrInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: addrInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: addrInput.enabled ? "white": "transparent"
                            property alias borderColor: addrInputBg.border.color
                            border {
                                color: addrInput.focus ? "#21be2b": "transparent"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                }   
            }

            Rectangle {
                id: contactEdit
                width: 350
                height: 35
                color: "transparent"

                anchors {
                    top: addrEdit.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
                Row {
                    spacing: 10

                    Label {
                        id: contactLabel
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }             
                            font.bold:          true
                            font.pointSize:     10
                            text:               "联系人:"
                        }
                    }

                    TextField {
                        id: contactInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: contactInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: contactInput.enabled ? "white": "transparent"
                            property alias borderColor: contactInputBg.border.color
                            border {
                                color: contactInput.focus ? "#21be2b": "transparent"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                }   
            }

            Rectangle {
                id: telEdit
                width: 350
                height: 35
                color: "transparent"

                anchors {
                    top: contactEdit.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
                Row {
                    spacing: 10

                    Label {
                        id: telLabel
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }             
                            font.bold:          true
                            font.pointSize:     10
                            text:               "联系电话:"
                        }
                    }

                    TextField {
                        id: telInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: telInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: telInput.enabled ? "white": "transparent"
                            property alias borderColor: telInputBg.border.color
                            border {
                                color: telInput.focus ? "#21be2b": "transparent"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                }   
            }

            CustomButton {
                id: confirmBtn
                text: "确认保存"
                colorDefault: Qt.lighter("blue")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                anchors {
                    bottomMargin: 35
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                implicitWidth: 100
                implicitHeight: 30

                onClicked: {
                    if (hotelNameInput.text.trim() === "") {
                        hotelNameInput.focus = true;
                        return;
                    }
                    if (addrInput.text.trim() === "") {
                        addrInput.focus = true;
                        return;
                    }
                    if (contactInput.text.trim() === "") {
                        contactInput.focus = true;
                        return;
                    }
                    if (telInput.text.trim() === "") {
                        telInput.focus = true;
                        return;
                    }
                    hotelModel.add_hotel(hotelNameInput.text,
                                         addrInput.text,
                                         contactInput.text,
                                         telInput.text);
                    hotelModel.init_Data();
                    newHotelPop.close();
                }
            }
        }
    }

    anchors {
        centerIn: parent
    }
}