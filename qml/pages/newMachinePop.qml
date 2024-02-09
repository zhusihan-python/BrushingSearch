import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.5
import "../components"

Popup {
    id: newMachinePop
    modal: true
    focus: true
    padding: 0
    width: 600
    height: 680
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
                    text: "添加机器"
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
                    onClicked: newMachinePop.close()
                }
            }

            Rectangle {
                id: machinelNameEdit
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
                        id: machineNameLabel
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }
                            font.bold:          true
                            font.pointSize:     10
                            text:               "机器编码:"
                        }
                    }
                    
                    TextField {
                        id: machineNameInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: machineNameInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: machineNameInput.enabled ? "white": "transparent"
                            property alias borderColor: machineNameInputBg.border.color
                            border {
                                color: machineNameInput.focus ? "#21be2b": "transparent"
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
                    top: machinelNameEdit.bottom
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
                            text:               "手机号码:"
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

            Rectangle {
                id: identityEdit
                width: 350
                height: 35
                color: "transparent"

                anchors {
                    top: telEdit.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
                Row {
                    spacing: 10

                    Label {
                        id: identityLabel
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }             
                            font.bold:          true
                            font.pointSize:     10
                            text:               "实名人:"
                        }
                    }

                    TextField {
                        id: identityInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: identityInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: identityInput.enabled ? "white": "transparent"
                            property alias borderColor: identityInputBg.border.color
                            border {
                                color: identityInput.focus ? "#21be2b": "transparent"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                }   
            }

            Rectangle {
                id: cardTypeEdit
                width: 350
                height: 35
                color: "transparent"

                anchors {
                    top: identityEdit.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
                Row {
                    spacing: 10

                    Label {
                        id: cardTypeLabel
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }             
                            font.bold:          true
                            font.pointSize:     10
                            text:               "卡类型:"
                        }
                    }

                    TextField {
                        id: cardTypeInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: cardTypeInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: cardTypeInput.enabled ? "white": "transparent"
                            property alias borderColor: cardTypeInputBg.border.color
                            border {
                                color: cardTypeInput.focus ? "#21be2b": "transparent"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                }   
            }

            Rectangle {
                id: cardFeeEdit
                width: 350
                height: 35
                color: "transparent"

                anchors {
                    top: cardTypeEdit.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
                Row {
                    spacing: 10

                    Label {
                        id: cardFeeLabel
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }             
                            font.bold:          true
                            font.pointSize:     10
                            text:               "卡费用:"
                        }
                    }

                    TextField {
                        id: cardFeeInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: cardFeeInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: cardFeeInput.enabled ? "white": "transparent"
                            property alias borderColor: cardFeeInputBg.border.color
                            border {
                                color: cardFeeInput.focus ? "#21be2b": "transparent"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                }   
            }

            Rectangle {
                id: operaterEdit
                width: 350
                height: 35
                color: "transparent"

                anchors {
                    top: cardFeeEdit.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
                Row {
                    spacing: 10

                    Label {
                        id: operaterLabel
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }             
                            font.bold:          true
                            font.pointSize:     10
                            text:               "运营商:"
                        }
                    }

                    ComboBox {
                        id: operaterSelector
                        width: 150
                        height: 25
                        model: ListModel {
                            ListElement { text: "中国移动" }
                            ListElement { text: "中国联通" }
                            ListElement { text: "中国电信" }
                            ListElement { text: "中国广电" }
                            ListElement { text: "中信网络" }
                        }
                    }
                }
            }

            Rectangle {
                id: meituanEdit
                width: 100
                height: 35
                color: "transparent"

                anchors {
                    top: operaterEdit.bottom
                    topMargin: 40
                    right: xiechengEdit.left
                    rightMargin: 10
                }

                Row {
                    spacing: 10
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold:          true
                        font.pointSize:     10
                        text:               "美团:"
                    }
                    CheckBox {
                        id: meituanCheck
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle {
                id: xiechengEdit
                width: 100
                height: 35
                color: "transparent"

                anchors {
                    top: operaterEdit.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }

                Row {
                    spacing: 10
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold:          true
                        font.pointSize:     10
                        text:               "携程:"
                    }
                    CheckBox {
                        id: xiechengCheck
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle {
                id: feizhuEdit
                width: 100
                height: 35
                color: "transparent"

                anchors {
                    top: operaterEdit.bottom
                    topMargin: 40
                    left: xiechengEdit.right
                    leftMargin: 10
                }

                Row {
                    spacing: 10
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold:          true
                        font.pointSize:     10
                        text:               "飞猪:"
                    }
                    CheckBox {
                        id: feizhuCheck
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle {
                id: qunaEdit
                width: 100
                height: 35
                color: "transparent"

                anchors {
                    top: meituanEdit.bottom
                    topMargin: 10
                    right: dazhongEdit.left
                    rightMargin: 10
                }

                Row {
                    spacing: 10
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold:          true
                        font.pointSize:     10
                        text:               "去哪儿:"
                    }
                    CheckBox {
                        id: qunaCheck
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle {
                id: dazhongEdit
                width: 100
                height: 35
                color: "transparent"

                anchors {
                    top: meituanEdit.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }

                Row {
                    spacing: 10
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold:          true
                        font.pointSize:     10
                        text:               "大众点评:"
                    }
                    CheckBox {
                        id: dazhongCheck
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle {
                id: tujiaEdit
                width: 100
                height: 35
                color: "transparent"

                anchors {
                    top: meituanEdit.bottom
                    topMargin: 10
                    left: dazhongEdit.right
                    leftMargin: 10
                }

                Row {
                    spacing: 10
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold:          true
                        font.pointSize:     10
                        text:               "途家旅行:"
                    }
                    CheckBox {
                        id: tujiaCheck
                        anchors.verticalCenter: parent.verticalCenter
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
                    if (machineNameInput.text.trim() === "") {
                        machineNameInput.focus = true;
                        return;
                    }
                    if (telInput.text.trim() === "") {
                        telInput.focus = true;
                        return;
                    }
                    if (identityInput.text.trim() === "") {
                        identityInput.focus = true;
                        return;
                    }
                    if (cardTypeInput.text.trim() === "") {
                        cardTypeInput.focus = true;
                        return;
                    }
                    if (cardFeeInput.text.trim() === "") {
                        cardFeeInput.focus = true;
                        return;
                    }
                    machineModel.add_machine(machineNameInput.text,
                                             telInput.text,
                                             identityInput.text,
                                             cardTypeInput.text,
                                             cardFeeInput.text,
                                             operaterSelector.currentIndex);
                    machineModel.init_data();
                    newMachinePop.close();
                }
            }
        }
    }

    anchors {
        centerIn: parent
    }
}