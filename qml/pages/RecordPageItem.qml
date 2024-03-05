import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.5
import Qt.labs.qmlmodels 1.0
import assets 1.0
import "../components"
import "../js/messageBox.js" as MessageBox

Item {
    property int machine_id: -1
    property var orderImgModel: ListModel {}
    property var commentImgModel: ListModel {}
    Rectangle {
        id: dataInputItem
        anchors.fill: parent
        color: "#e6eef6"

        Row {
            id: dataInputFilter
            height: 25
            spacing: 15

            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                leftMargin: 10
            }

            TextField {
                id: machineNameTxt
                width: 200
                height: 25
                selectByMouse: true

                property int lengthLimit: 25
                property var listModel: ListModel {} // 数据模型
                background: Rectangle {
                    implicitWidth: 150; implicitHeight: 30
                    color: machineNameTxt.enabled ? "white": "transparent"

                    border {
                        color: machineNameTxt.focus ? "#21be2b": "grey"
                    }
                }

                onTextChanged: {
                    // 模糊搜索逻辑
                    if (length > lengthLimit) remove(lengthLimit, length);
                    if (text) {
                        // 从数据源搜索过滤结果到listModel
                        machineCombo.init_data(text);
                        machine_item_pop.open();
                    }
                }

                Popup {
                    id: machine_item_pop
                    y: machineNameTxt.height
                    width: machineNameTxt.width
                    height: 160
                    signal machineSelected(int index)

                    ListView {
                        id: hotelLView
                        model: machineCombo
                        height: 150
                        width: 190
                        
                        delegate: ItemDelegate {
                                    width: 190
                                    height: 20
                                    text: model.display
                                    background: Rectangle {
                                        width: 180
                                        radius: 5
                                        color: {
                                            if (parent.hovered)
                                                return "lightsteelblue";
                                            return "white";
                                        }
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            machine_item_pop.close();
                                            machineNameText.text = model.display;
                                            machine_item_pop.machineSelected(index);
                                        }
                                    }
                                }
                        focus: true
                        keyNavigationWraps: true
                        ScrollBar.vertical: ScrollBar {
                            id: machineScroll
                            size: 0.3
                            width: 10
                            policy: ScrollBar.AlwaysOn

                            contentItem: Rectangle {
                                implicitWidth: 3
                                implicitHeight: 100
                                radius: width / 2
                                color: machineScroll.pressed ? "darkgrey" : "lightgrey"
                                opacity: machineScroll.policy === ScrollBar.AlwaysOn || (machineScroll.active && machineScroll.size < 1.0) ? 0.75 : 0
                            }
                        }
                    }
                }
            }

            Label {
                id: machineLabel
                width: 60
                height: 25
                text: "机器编号："
                font.bold: true
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: machineNameText
                text: ""
                width: 150
                height: 25
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: paltformLabelTwo
                width: 60
                height: 25
                text: "APP平台："
                font.bold: true
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
            }

            ComboBox {
                id: paltformSelectorTwo
                width: 150
                height: 25
                model: platformCombo
                textRole: "display"
            }
        }

        Rectangle {
            id: dataEditArea
            anchors {
                top: dataInputFilter.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: 5
            }
            border {
                color: "grey"
                width: 1
            }
            ButtonGroup { id: paymentGroup }
            ButtonGroup { id: paidGroup }
            Column {
                spacing: 20
                anchors {
                    top: parent.top
                    topMargin: 20
                    left: parent.left
                    leftMargin: 20
                }
                Row {
                    spacing: 10

                    Label {
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
                        id: nameEditInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: nameEditInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: nameEditInput.enabled ? "white": "transparent"
                            property alias borderColor: nameEditInputBg.border.color
                            border {
                                color: nameEditInput.focus ? "#21be2b": "gray"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                    Label {
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }
                            font.bold:          true
                            font.pointSize:     10
                            text:               "代付人:"
                        }
                    }
                    TextField {
                        id: payorInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: payorInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: payorInput.enabled ? "white": "transparent"
                            property alias borderColor: payorInputBg.border.color
                            border {
                                color: payorInput.focus ? "#21be2b": "gray"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                    Label {
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }
                            font.bold:          true
                            font.pointSize:     10
                            text:               "金额:"
                        }
                    }
                    TextField {
                        id: moneyInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")
                        validator: RegularExpressionValidator { regularExpression: /^(?!0\d)(\d{1,7})(\.\d{1,2})?$/ }
                        property int lengthLimit: 20

                        background: Rectangle {
                            id: moneyInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: moneyInput.enabled ? "white": "transparent"
                            property alias borderColor: moneyInputBg.border.color
                            border {
                                color: moneyInput.focus ? "#21be2b": "gray"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                    Label {
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }
                            font.bold:          true
                            font.pointSize:     10
                            text:               "支付方式:"
                        }
                    }
                    RadioButton {
                        text: qsTr("支付宝")
                        ButtonGroup.group: paymentGroup
                    }
                    RadioButton {
                        text: qsTr("微信")
                        ButtonGroup.group: paymentGroup
                    }
                    RadioButton {
                        text: qsTr("其他")
                        ButtonGroup.group: paymentGroup
                    }
                }
                Row {
                    spacing: 10

                    Label {
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }
                            font.bold:          true
                            font.pointSize:     10
                            text:               "入住人:"
                        }
                    }
                    TextField {
                        id: tenantInput
                        selectByMouse: true
                        placeholderText: qsTr("不允许为空")

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: tenantInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: tenantInput.enabled ? "white": "transparent"
                            property alias borderColor: tenantInputBg.border.color
                            border {
                                color: tenantInput.focus ? "#21be2b": "gray"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                    Label {
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }
                            font.bold:          true
                            font.pointSize:     10
                            text:               "电话:"
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
                                color: telInput.focus ? "#21be2b": "gray"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                    Label {
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }
                            font.bold:          true
                            font.pointSize:     10
                            text:               "是否结账:"
                        }
                    }
                    RadioButton {
                        text: qsTr("是")
                        ButtonGroup.group: paidGroup
                    }
                    RadioButton {
                        text: qsTr("否")
                        ButtonGroup.group: paidGroup
                    }
                }
                Row {
                    spacing: 10

                    Label {
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }
                            font.bold:          true
                            font.pointSize:     10
                            text:               "下单日期:"
                        }
                    }
                    CustomDatePicker { id: orderDatePicker }
                    Label {
                        width: 310
                        height: 30
                    }
                    Label {
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }
                            font.bold:          true
                            font.pointSize:     10
                            text:               "评论日期:"
                        }
                    }
                    CustomDatePicker { id: commentDatePicker }
                }
                Row {
                    spacing: 10

                    Rectangle {
                        id: orderImgArea
                        width: 620
                        height: 150
                        border.color: "gray"
                        DropArea {
                            id: orderImgDrop;
                            anchors.fill: parent
                            onEntered: (drag) => {
                                orderImgArea.color = "gray";
                                drag.accept (Qt.LinkAction);
                            }
                            onDropped: (drop) => {
                                console.log(drop.urls);
                                if ((drop.urls.length + orderImgModel.count) > 5) {
                                    MessageBox.showMessageBox("最多上传五张图片", "提示");
                                } else {
                                    if (drop.urls.length > 0) {
                                        for (let i = 0;i < drop.urls.length;i++) {
                                            orderImgModel.append({ srcFile: drop.urls[i] });
                                        }
                                    }
                                }
                                orderImgArea.color = "white"
                            }
                            onExited: {
                                orderImgArea.color = "white";
                            }
                            ListView {
                                height: 200
                                anchors {
                                    topMargin: 10
                                    top: parent.top
                                    leftMargin: 10
                                    left: parent.left
                                    right: parent.right
                                }
                                orientation: ListView.Horizontal
                                layoutDirection: Qt.LeftToRight
                                spacing: 10
                                model: orderImgModel
                                delegate: Column {
                                    spacing: 5
                                    Image {
                                        width: 100; height: 100
                                        source: srcFile
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Text {
                                        id: delText
                                        text: "删除"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        MouseArea {
                                            hoverEnabled: true 
                                            anchors.fill: parent
                                            onClicked: {
                                                orderImgModel.remove(index, 1);
                                            }
                                            onEntered: {
                                                delText.font.underline = true;
                                            }
                                            onExited: {
                                                delText.font.underline = false;
                                            }
                                        }
                                    }
                                }                               
                            }
                        }
                    }
                    Rectangle {
                        id: commentImgArea
                        width: 620
                        height: 150
                        border.color: "gray"
                        DropArea {
                            id: commentImgDrop;
                            anchors.fill: parent
                            onEntered: (drag) => {
                                commentImgArea.color = "gray";
                                drag.accept (Qt.LinkAction);
                            }
                            onDropped: (drop) => {
                                console.log(drop.urls)
                                commentImgArea.color = "white"
                            }
                            onExited: {
                                commentImgArea.color = "white";
                            }
                        }
                    }
                }
            }
        }
    }
    Connections {
        target: machine_item_pop

        function onMachineSelected(index) {
            machine_id = machineCombo.get_machine_number(index);
        }
    }
}