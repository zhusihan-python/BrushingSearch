import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Dialogs
import Qt.labs.qmlmodels 1.0

Item {
    property string destination: fileDialog.selectedFile
    property int export_type: 0
    Rectangle {
        anchors.fill: parent
        color: "#e6eef6"
        
        Row {
            id: historyFilterRow
            height: 25
            spacing: 15

            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                leftMargin: 10
            }

            TextField {
                id: recordIdTextField
                width: 150
                height: 25
                selectByMouse: true
                validator: RegularExpressionValidator { regularExpression: /^[0-9]{1,}$/ }

                property int lengthLimit: 20
                background: Rectangle {
                    implicitWidth: 150; implicitHeight: 30
                    color: recordIdTextField.enabled ? "white": "transparent"

                    border {
                        color: recordIdTextField.focus ? "#21be2b": "grey"
                    }
                }
                onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
            }

            CustomButton {
                id: historyRecentWeekBtn
                text: qsTr("最近一周")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"

                width: 100
                height: 25

            }

            CustomButton {
                id: queryBtn
                text: qsTr("查询")
                colorDefault: Qt.lighter("blue")
                radius: 15
                textColor: "white"

                implicitWidth: 100
                implicitHeight: 25

                onClicked: {
                    let record_id = recordIdTextField.text;
                    let operator_id = operatorCombo.get_operator_id(operatorSelector.currentIndex);
                    historyRecordModel.init_data(startDatePicker.dateText, endDatePicker.dateText, record_id, operator_id.toString());
                }
            }

            CustomButton {
                id: exportBtn
                text: qsTr("导出")
                colorDefault: Qt.lighter("blue")
                radius: 15
                textColor: "white"

                implicitWidth: 100
                implicitHeight: 25

                onClicked: {
                    if ( history_table_view.selectedRows.size > 0 ) {
                        export_type = 0;
                        fileDialog.open();
                    } else {
                        MessageBox.showMessageBox("请选择记录", "提示");
                    }
                }
            }

            CustomButton {
                id: reportBtn
                text: qsTr("玻片运行报告")
                colorDefault: Qt.lighter("blue")
                radius: 15
                textColor: "white"

                implicitWidth: 100
                implicitHeight: 25

                onClicked: {
                    console.log("history_table_view.selectedRows.size", history_table_view.selectedRows.size);
                    if (  history_table_view.selectedRows.size > 0 && history_table_view.selectedRows.size <= 12 ) {
                        export_type = 1;
                        fileDialog.open();
                    } else if ( history_table_view.selectedRows.size === 0 ) {
                        MessageBox.showMessageBox("请选择记录", "提示");
                    } else if ( history_table_view.selectedRows.size > 12 ) {
                        MessageBox.showMessageBox("单次超过12个玻片记录", "提示");
                    }
                }
            }

            FileDialog {
                id: fileDialog
                fileMode: FileDialog.SaveFile
                nameFilters: ["PDF files (*.pdf)"]
                 onAccepted: {
                    // console.log("User has selected " + fileDialog.selectedFile, destination);
                    fileDialog.close();
                    pdfWriter.write_to_file_path(destination.toString(), [...history_table_view.selectedRows], export_type);
                }
            }
        }

        Rectangle {
            id: historyTable
            width: 1720
            // height: 780
            border {
                color: "grey"
                width: 1
            }

            property int verHeaderHeight: 20
            property int verHeaderWidth: 50
            property int horHeaderHeight: 20
            property int horHeaderWidth: 30
            property color scrollBarColor: Qt.lighter("grey")
            property int scrollBarWidth: 6
            // property int finished: 0
            property variant columnWidthArr: [150, 150, 360, 150, 160, 160, 150, 360]

            anchors {
                // bottom: parent.bottom
                top: historyFilterRow.bottom
                topMargin: 10
                bottom: parent.bottom
                bottomMargin: 15
                left: parent.left
                leftMargin: 10
            }

            TableView {
                id: history_table_view
                anchors {
                    fill: parent
                    leftMargin: historyTable.verHeaderWidth
                    topMargin: historyTable.horHeaderHeight
                    bottomMargin: 1
                }

                clip: true
                boundsBehavior: Flickable.StopAtBounds
                columnSpacing: 0
                rowSpacing: 0

                property var selectedRows: new Set()

                rowHeightProvider: function (row) {
                    return historyTable.verHeaderHeight;
                }

                columnWidthProvider: function (column) {
                    return historyTable.columnWidthArr[column];
                }

                model: historyRecordModel

                delegate: DelegateChooser {
                    DelegateChoice {
                        delegate: Rectangle {
                                color: (checkRepeater.itemAt(model.row).checked) ? "lightsteelblue" : 
                                    ((model.row %2 ===0) ? "white": "#F6F6F6");

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
                width: historyTable.verHeaderWidth
                height: historyTable.verHeaderHeight
                color: "#F8F8F8"
                anchors {
                    top: parent.top
                    left: parent.left
                }
                CheckBox {
                    id: checkBox
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 0
                    }
                    onClicked: {
                        console.log("checkBox", checkBox.checked);
                        let count = historyRecordModel.rowCount(0);
                        console.log("historyRecordModel count", count);
                        if (!count) {
                            return false
                        }

                        for (let i = 0; i < count; i++) {
                            checkRepeater.itemAt(i).checked = checkBox.checked;
                            if (checkBox.checked) {
                                history_table_view.selectedRows.add(i);
                            } else {
                                history_table_view.selectedRows.delete(i);
                            }
                        }
                    }
                }
                Text {
                    anchors {
                        verticalCenter: checkBox.verticalCenter
                        left: checkBox.right
                        leftMargin: 0
                    }

                    text: checkBox.checked ? "取消" : "全选"
                    font.pixelSize: 12
                    color: "#707070"
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
                    topMargin: historyTable.verHeaderHeight
                    bottom: parent.bottom
                    bottomMargin: 1
                }
                topPadding: -history_table_view.contentY
                z: 2
                clip: true
                // spacing: 1
                Repeater {
                    id: checkRepeater
                    model: history_table_view.rows > 0 ? history_table_view.rows : 0
                    Rectangle {
                        width: historyTable.verHeaderWidth
                        height: history_table_view.rowHeightProvider(index)
                        color: "white"
                        property alias checked: rowCheckBox.checked
                        CheckBox {
                            id: rowCheckBox
                            anchors.centerIn: parent

                            onClicked: {
                                if ( rowCheckBox.checked ) {
                                    if ( ! (history_table_view.selectedRows.has(index)) ) {
                                        history_table_view.selectedRows.add(index);
                                    }
                                    // for (let item of history_table_view.selectedRows) console.log(item);
                                } else if ( !rowCheckBox.checked ) {
                                    if ( history_table_view.selectedRows.has(index) ) {
                                        history_table_view.selectedRows.delete(index);
                                    }
                                    // for (let item of history_table_view.selectedRows) console.log(item);
                                }
                            }
                        }
                    }
                }
            }

            // horizon header
            Item {
                id: header_horizontal

                anchors{
                    left: parent.left
                    right: parent.right
                    leftMargin: historyTable.verHeaderWidth
                }
                height: historyTable.horHeaderHeight
                z: 2
                //暂存鼠标拖动的位置
                property int posXTemp: 0
                MouseArea{
                    anchors.fill: parent
                    onPressed: header_horizontal.posXTemp=mouseX;
                    onPositionChanged: {
                        if (history_table_view.contentX + (header_horizontal.posXTemp-mouseX)>0) {
                            history_table_view.contentX += (header_horizontal.posXTemp-mouseX);
                        } else {
                            history_table_view.contentX=0;
                        }
                        header_horizontal.posXTemp=mouseX;
                    }
                }

                Row {
                    id: header_horizontal_row
                    anchors.fill: parent
                    leftPadding: -history_table_view.contentX
                    clip: true
                    spacing: 0
        
                    Repeater {
                        model: history_table_view.columns > 0 ? history_table_view.columns : 0
        
                        Rectangle {
                            id: reagent_header_horizontal
                            width: history_table_view.columnWidthProvider(index)+history_table_view.columnSpacing
                            height: historyTable.horHeaderHeight

                            Rectangle {
                                id: headerItemBg
                                height: historyTable.horHeaderHeight
                                anchors.fill: parent

                                Canvas {
                                    implicitWidth: reagent_header_horizontal.width;
                                    implicitHeight: historyTable.horHeaderHeight;
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
                                text: historyRecordModel.headerData(index, Qt.Horizontal)
                                // text: historyRecordModel.horHeader[index]
                            }

                            MouseArea {
                                width: 3
                                height: parent.height
                                anchors.right: parent.right
                                cursorShape: Qt.SplitHCursor
                                onPressed: header_horizontal.posXTemp=mouseX;
                                onPositionChanged: {
                                    if((reagent_header_horizontal.width-(header_horizontal.posXTemp-mouseX))>10){
                                        reagent_header_horizontal.width-=(header_horizontal.posXTemp-mouseX);
                                    }else{
                                        reagent_header_horizontal.width=10;
                                    }
                                    header_horizontal.posXTemp=mouseX;
                                    historyTable.columnWidthArr[index]=(reagent_header_horizontal.width-history_table_view.columnSpacing);
                                    //刷新布局，这样宽度才会改变
                                    history_table_view.forceLayout();
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function setRecentWeek() {
        let date = new Date();
        endDatePicker.dateText = date.getFullYear()+"-"+(date.getMonth()+1).toString().padStart(2, "0")+"-"+ date.getDate().toString().padStart(2, "0");
        date.setDate(date.getDate() - 7);
        startDatePicker.dateText = date.getFullYear()+"-"+(date.getMonth()+1).toString().padStart(2, "0")+"-"+ date.getDate().toString().padStart(2, "0");
    }

    Component.onCompleted: {
        setRecentWeek();
        historyRecordModel.init_data("", "", "", "");
    }
}