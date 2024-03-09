import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.5
import Qt.labs.platform
import Qt.labs.qmlmodels 1.0
import assets 1.0
import "../components"
import "../js/messageBox.js" as MessageBox

Item {
    property int machine_id: -1
    property var orderImgModel: ListModel {}
    property var commentImgModel: ListModel {}
    property ListModel rImgModel: ListModel {}

    FileDialog {
        id: fileDialog
        options: FileDialog.DontUseNativeDialog
        fileMode: FileDialog.OpenFiles
        nameFilters: ["Image Files (*.png *.jpg)", "All Files (*)"]
        onAccepted: {
            console.log("User has selected " + fileDialog.currentFiles);
            if (orderImgModel.count + fileDialog.currentFiles.length <= 5) {
                for (let i=0;i<fileDialog.currentFiles.length;i++) {
                    orderImgModel.append({ srcFile: fileDialog.currentFiles[i] });
                }
            }
            fileDialog.currentFiles.length = 0;
            fileDialog.close();
        }
    }
    FileDialog {
        id: fileDialog2
        options: FileDialog.DontUseNativeDialog
        fileMode: FileDialog.OpenFiles
        nameFilters: ["Image Files (*.png *.jpg)", "All Files (*)"]
        onAccepted: {
            console.log("User has selected " + fileDialog2.currentFiles);
            if (commentImgModel.count + fileDialog2.currentFiles.length <= 5) {
                for (let i=0;i<fileDialog2.currentFiles.length;i++) {
                    commentImgModel.append({ srcFile: fileDialog2.currentFiles[i] });
                }
            }
            fileDialog2.currentFiles.length = 0;
            fileDialog2.close();
        }
    }
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
                id: editColumn
                spacing: 20
                anchors {
                    top: parent.top
                    topMargin: 20
                    left: parent.left
                    leftMargin: 20
                }
                Row {
                    spacing: 20

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
                    spacing: 20

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
                        validator: RegularExpressionValidator { regularExpression: /^[1][3,5,7,8][0-9]\\d{8}$/ }
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
                    spacing: 20

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
                    CustomButton {
                        id: uploadOrderBtn
                        text: qsTr("上传")
                        colorDefault: Qt.lighter("blue")
                        colorPressed: "#55aaff"
                        colorMouseOver: "#40405f"

                        implicitWidth: 100
                        implicitHeight: 25

                        onClicked: {
                            fileDialog.open();
                        }
                    }
                    Label {
                        width: 190
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
                    CustomButton {
                        id: uploadCommentBtn
                        text: qsTr("上传")
                        colorDefault: Qt.lighter("blue")
                        colorPressed: "#55aaff"
                        colorMouseOver: "#40405f"

                        implicitWidth: 100
                        implicitHeight: 25

                        onClicked: {
                            fileDialog2.open();
                        }
                    }
                }
                Row {
                    spacing: 20

                    Rectangle {
                        id: orderImgArea
                        width: 650
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
                                        width: 110; height: 110
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
                        width: 650
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
                                console.log(drop.urls);
                                if ((drop.urls.length + commentImgModel.count) > 5) {
                                    MessageBox.showMessageBox("最多上传五张图片", "提示");
                                } else {
                                    if (drop.urls.length > 0) {
                                        for (let i = 0;i < drop.urls.length;i++) {
                                            commentImgModel.append({ srcFile: drop.urls[i] });
                                        }
                                    }
                                }
                                commentImgArea.color = "white"
                            }
                            onExited: {
                                commentImgArea.color = "white";
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
                                model: commentImgModel
                                delegate: Column {
                                    spacing: 5
                                    Image {
                                        width: 110; height: 110
                                        source: srcFile
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Text {
                                        id: delText2
                                        text: "删除"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        MouseArea {
                                            hoverEnabled: true
                                            anchors.fill: parent
                                            onClicked: {
                                                commentImgModel.remove(index, 1);
                                            }
                                            onEntered: {
                                                delText2.font.underline = true;
                                            }
                                            onExited: {
                                                delText2.font.underline = false;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Row {
                    spacing: 20

                    Label {
                        width: 50
                        height: 30

                        Text {
                            anchors {
                                centerIn: parent
                            }
                            font.bold:          true
                            font.pointSize:     10
                            text:               "IP地址:"
                        }
                    }
                    TextField {
                        id: ipInput
                        selectByMouse: true
                        validator: RegularExpressionValidator { regularExpression: /^((2((5[0-5])|([0-4]\d)))|([0-1]?\d{1,2}))(\.((2((5[0-5])|([0-4]\d)))|([0-1]?\d{1,2}))){3}$/ }
                        property int lengthLimit: 15

                        background: Rectangle {
                            id: ipInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: ipInput.enabled ? "white": "transparent"
                            property alias borderColor: ipInputBg.border.color
                            border {
                                color: ipInput.focus ? "#21be2b": "gray"
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
                            text:               "静态服务器:"
                        }
                    }
                    TextField {
                        id: staticServerInput
                        selectByMouse: true

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: staticServerInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: staticServerInput.enabled ? "white": "transparent"
                            property alias borderColor: staticServerInputBg.border.color
                            border {
                                color: staticServerInput.focus ? "#21be2b": "gray"
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
                            text:               "备注:"
                        }
                    }
                    TextField {
                        id: commentInput
                        selectByMouse: true

                        property int lengthLimit: 20

                        background: Rectangle {
                            id: commentInputBg
                            implicitWidth: 250; implicitHeight: 30
                            color: commentInput.enabled ? "white": "transparent"
                            property alias borderColor: commentInputBg.border.color
                            border {
                                color: commentInput.focus ? "#21be2b": "gray"
                            }
                        }
                        onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
                    }
                    CustomButton {
                        id: saveDataBtn
                        text: qsTr("保 存")
                        colorDefault: Qt.lighter("blue")
                        colorPressed: "#55aaff"
                        colorMouseOver: "#40405f"

                        implicitWidth: 120
                        implicitHeight: 30

                        onClicked: {

                        }
                    }
                }
            }
            Rectangle {
                id: recordTable
                width: parent.width
                border {
                    color: "grey"
                    width: 1
                }

                property int verHeaderHeight: 20
                property int verHeaderWidth: 1
                property int horHeaderHeight: 20
                property int horHeaderWidth: 30
                property color scrollBarColor: Qt.lighter("grey")
                property int scrollBarWidth: 6
                // property int finished: 0
                property variant columnWidthArr: [80, 120, 200, 120, 80, 80, 80, 80, 80, 120, 120, 280, 280, 90]

                anchors {
                    // bottom: parent.bottom
                    top: editColumn.bottom
                    topMargin: 15
                    bottom: parent.bottom
                    bottomMargin: 10
                    left: parent.left
                    leftMargin: 5
                    right: parent.right
                    rightMargin: 5
                }

                TableView {
                    id: record_tbview
                    anchors {
                        fill: parent
                        leftMargin: recordTable.verHeaderWidth
                        topMargin: recordTable.horHeaderHeight
                        bottomMargin: 1
                    }

                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    columnSpacing: 0
                    rowSpacing: 0

                    property var selectedRows: new Set()

                    rowHeightProvider: function (row) {
                        return recordTable.verHeaderHeight;
                    }

                    columnWidthProvider: function (column) {
                        return recordTable.columnWidthArr[column];
                    }

                    model: recordModel

                    delegate: DelegateChooser {
                        DelegateChoice {
                            column: 11
                            delegate: Rectangle {
                                        id: commentFrame
                                        width: 280
                                        height: 20
                                        clip: true
                                        color: (model.row %2 ===0) ? "white": "#F6F6F6";

                                        Row {
                                            width: parent.width
                                            spacing: 5
                                            Repeater {
                                                id: commentReapter
                                                property int imageCount: 0
                                                model: imageCount
                                                Text {
                                                    color: "blue"
                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onPressed: {
                                                            let comment_imgs = recordModel.get_comment_imgs(row);
                                                            rImgModel.clear();
                                                            for (let j=0;j<comment_imgs.length;j++) {
                                                                rImgModel.append({"source": comment_imgs[j]});
                                                            }
                                                            rPathView.model = rImgModel;
                                                            rPathView.currentIndex = index;
                                                            rPopup.visible = true;
                                                        }
                                                    }
                                                }
                                                Component.onCompleted: {
                                                    if (typeof(display) === 'string' && display.length > 0) {
                                                        let splitted = display.split(',');
                                                        imageCount = splitted.length;
                                                        for (let i=0;i<imageCount;i++) {
                                                            commentReapter.itemAt(i).text = "图片"+(i+1).toString();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                        }
                        DelegateChoice {
                            column: 12
                            // roleValue: "order_img"
                            delegate: Rectangle {
                                        id: orderFrame
                                        width: 280
                                        height: 20
                                        clip: true
                                        color: (model.row %2 ===0) ? "white": "#F6F6F6";

                                        Row {
                                            width: parent.width
                                            spacing: 5
                                            Repeater {
                                                id: imageReapter
                                                property int imageCount: 0
                                                model: imageCount
                                                Text {
                                                    color: "blue"
                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onPressed: {
                                                            let order_imgs = recordModel.get_order_imgs(row);
                                                            rImgModel.clear();
                                                            for (let j=0;j<order_imgs.length;j++) {
                                                                rImgModel.append({"source": order_imgs[j]});
                                                            }
                                                            rPathView.model = rImgModel;
                                                            rPathView.currentIndex = index;
                                                            rPopup.visible = true;
                                                        }
                                                    }
                                                }
                                                Component.onCompleted: {
                                                    if (typeof(display) === 'string' && display.length > 0) {
                                                        let splitted = display.split(',');
                                                        imageCount = splitted.length;
                                                        for (let i=0;i<imageCount;i++) {
                                                            imageReapter.itemAt(i).text = "图片"+(i+1).toString();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                        }
                        DelegateChoice {
                            delegate: Rectangle {
                                    color: (model.row %2 ===0) ? "white": "#F6F6F6";

                                    Text {
                                        anchors {
                                            centerIn: parent
                                        }
                                        text: display === undefined ? "" : display
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true

                                        onClicked: {}
                                    }
                                }
                            }
                    }
                }

                Rectangle {
                    width: recordTable.verHeaderWidth
                    height: recordTable.verHeaderHeight
                    color: "#F8F8F8"
                    anchors {
                        top: parent.top
                        left: parent.left
                    }
                    Rectangle {
                        height: 1
                        width: parent.width
                        anchors.bottom: parent.bottom
                        color: "#E5E5E5"
                    }
                    Rectangle {
                        height: 1
                        width: parent.width
                        anchors.top: parent.top
                        color: "#E5E5E5"
                    }
                }

                Column {

                    anchors {
                        top: parent.top
                        topMargin: recordTable.verHeaderHeight
                        bottom: parent.bottom
                        bottomMargin: 1
                    }
                    topPadding: -record_tbview.contentY
                    z: 2
                    clip: true
                    // spacing: 1
                }

                // horizon header
                Item {
                    id: record_header_horizontal

                    anchors{
                        left: parent.left
                        right: parent.right
                        leftMargin: recordTable.verHeaderWidth
                    }
                    height: recordTable.horHeaderHeight
                    z: 2
                    //暂存鼠标拖动的位置
                    property int posXTemp: 0
                    MouseArea{
                        anchors.fill: parent
                        onPressed: record_header_horizontal.posXTemp=mouseX;
                        onPositionChanged: {
                            if (record_tbview.contentX + (record_header_horizontal.posXTemp-mouseX)>0) {
                                record_tbview.contentX += (record_header_horizontal.posXTemp-mouseX);
                            } else {
                                record_tbview.contentX=0;
                            }
                            record_header_horizontal.posXTemp=mouseX;
                        }
                    }

                    Row {
                        // id: header_horizontal_row
                        anchors.fill: parent
                        leftPadding: -record_tbview.contentX
                        clip: true
                        spacing: 0
                        Repeater {
                            model: record_tbview.columns > 0 ? record_tbview.columns : 0

                            Rectangle {
                                id: reagent_header_horizontal
                                width: record_tbview.columnWidthProvider(index)+record_tbview.columnSpacing
                                height: recordTable.horHeaderHeight

                                Rectangle {
                                    id: headerItemBg
                                    height: recordTable.horHeaderHeight
                                    anchors.fill: parent

                                    Canvas {
                                        implicitWidth: reagent_header_horizontal.width;
                                        implicitHeight: recordTable.horHeaderHeight;
                                        onPaint: {
                                            var ctx = getContext("2d");
                                            var gradient = ctx.createLinearGradient(0, 0, 0, 32);
                                            gradient.addColorStop(0, "white");
                                            gradient.addColorStop(1, "#0edcfb");
                                            ctx.fillStyle = gradient;
                                            ctx.fillRect(0, 0, width, height);
                                            ctx.strokeStyle = "#D7D7DF";
                                            ctx.lineWidth = 2;
                                            ctx.save();
                                            ctx.beginPath();
                                            ctx.moveTo(0, 1);
                                            ctx.lineTo(canvasSize.width, 1);
                                            ctx.stroke();
                                            ctx.beginPath();
                                            ctx.moveTo(0, canvasSize.height - 1);
                                            ctx.lineTo(canvasSize.width, canvasSize.height - 1);
                                            ctx.stroke();
                                            ctx.font = "12pt sans-serif";
                                            ctx.textAlign = "center";
                                            ctx.fillStyle = "#000000";
                                            ctx.restore();
                                        }
                                    }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: recordModel.headerData(index, Qt.Horizontal)
                                }

                                MouseArea {
                                    width: 3
                                    height: parent.height
                                    anchors.right: parent.right
                                    cursorShape: Qt.SplitHCursor
                                    onPressed: record_header_horizontal.posXTemp=mouseX;
                                    onPositionChanged: {
                                        if((reagent_header_horizontal.width-(record_header_horizontal.posXTemp-mouseX))>10){
                                            reagent_header_horizontal.width-=(record_header_horizontal.posXTemp-mouseX);
                                        }else{
                                            reagent_header_horizontal.width=10;
                                        }
                                        record_header_horizontal.posXTemp=mouseX;
                                        recordTable.columnWidthArr[index]=(reagent_header_horizontal.width-record_tbview.columnSpacing);
                                        //刷新布局，这样宽度才会改变
                                        record_tbview.forceLayout();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Popup {
        id: rPopup
        width: 600
        height: 400
        visible: false
        background: Rectangle {
            color: "transparent"
            // border.color: "black"
        }
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        anchors.centerIn: parent
        property int itemCount: 3
        PathView{
            id: rPathView
            model: rImgModel
            delegate: Item {
                id:delegateItem
                width: 300
                height: 300
                z: PathView.iconZ
                scale: PathView.iconScale

                Image{
                    id:image
                    source: model.source
                    width: delegateItem.width
                    height: delegateItem.height
                }

                transform: Rotation{
                    origin.x:image.width/2.0
                    origin.y:image.height/2.0
                    axis{x:0;y:1;z:0}
                    angle: delegateItem.PathView.iconAngle
                }
            }
            path:rCoverFlowPath
            pathItemCount: rPopup.itemCount
            anchors.fill: parent

            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5

        }

        Path{
            id:rCoverFlowPath
            startX: 0
            startY: rPopup.height/3

            PathAttribute{name:"iconZ";value: 0}
            PathAttribute{name:"iconAngle";value: 70}
            PathAttribute{name:"iconScale";value: 0.6}
            PathLine{x:rPopup.width/2;y:rPopup.height/3}

            PathAttribute{name:"iconZ";value: 100}
            PathAttribute{name:"iconAngle";value: 0}
            PathAttribute{name:"iconScale";value: 1.0}

            PathLine{x:rPopup.width;y:rPopup.height/3}
            PathAttribute{name:"iconZ";value: 0}
            PathAttribute{name:"iconAngle";value: -70}
            PathAttribute{name:"iconScale";value: 0.6}
            PathPercent{value:1.0}

        }
    }
    Connections {
        target: machine_item_pop

        function onMachineSelected(index) {
            machine_id = machineCombo.get_machine_number(index);
        }
    }
}