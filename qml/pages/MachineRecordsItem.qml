import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Dialogs
import Qt.labs.qmlmodels 1.0
import "../components"

Item {
    property string destination: mRFileDialog.selectedFile
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
                id: mRecordIdTextField
                width: 150
                height: 25
                selectByMouse: true
                validator: RegularExpressionValidator { regularExpression: /^[0-9]{1,}$/ }

                property int lengthLimit: 20
                background: Rectangle {
                    implicitWidth: 150; implicitHeight: 30
                    color: mRecordIdTextField.enabled ? "white": "transparent"

                    border {
                        color: mRecordIdTextField.focus ? "#21be2b": "grey"
                    }
                }
                onTextChanged: if (length > lengthLimit) remove(lengthLimit, length);
            }

            CustomButton {
                id: mRQueryBtn
                text: qsTr("查询")
                colorDefault: Qt.lighter("blue")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                implicitWidth: 100
                implicitHeight: 25

                onClicked: {

                }
            }

            CustomButton {
                id: mRExportBtn
                text: qsTr("导出")
                colorDefault: Qt.lighter("blue")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"

                implicitWidth: 100
                implicitHeight: 25

                onClicked: {
                    if ( mRecord_tbview.selectedRows.size > 0 ) {
                        export_type = 0;
                        mRFileDialog.open();
                    } else {
                        // MessageBox.showMessageBox("请选择记录", "提示");
                    }
                }
            }

            FileDialog {
                id: mRFileDialog
                fileMode: FileDialog.SaveFile
                nameFilters: ["PDF files (*.pdf)"]
                 onAccepted: {
                    // console.log("User has selected " + mRFileDialog.selectedFile, destination);
                    mRFileDialog.close();
                    pdfWriter.write_to_file_path(destination.toString(), [...mRecord_tbview.selectedRows], export_type);
                }
            }
        }

        Rectangle {
            id: mRecordTable
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
                top: historyFilterRow.bottom
                topMargin: 10
                bottom: parent.bottom
                bottomMargin: 15
                left: parent.left
                leftMargin: 5
                right: parent.right
                rightMargin: 5
            }

            TableView {
                id: mRecord_tbview
                anchors {
                    fill: parent
                    leftMargin: mRecordTable.verHeaderWidth
                    topMargin: mRecordTable.horHeaderHeight
                    bottomMargin: 1
                }

                clip: true
                boundsBehavior: Flickable.StopAtBounds
                columnSpacing: 0
                rowSpacing: 0

                property var selectedRows: new Set()

                rowHeightProvider: function (row) {
                    return mRecordTable.verHeaderHeight;
                }

                columnWidthProvider: function (column) {
                    return mRecordTable.columnWidthArr[column];
                }

                model: machineRecordModel

                delegate: DelegateChooser {
                    // role: "role"
                    DelegateChoice {
                        column: 12
                        // roleValue: "order_img"
                        delegate: Item {
                                    id: photoFrame
                                    width: 100
                                    height: 40
                                    clip: true

                                    Image {
                                        id: imageItem
                                        focus: true
                                        width: 40
                                        height: 40
                                        source : "file:///F:/projects/BrushingSearch/images/images/fingerprint.png"
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                // popupImage.source = "file:///F:/projects/BrushingSearch/images/images/fingerprint.png";
                                                popup.visible = true;
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
                width: mRecordTable.verHeaderWidth
                height: mRecordTable.verHeaderHeight
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
                    topMargin: mRecordTable.verHeaderHeight
                    bottom: parent.bottom
                    bottomMargin: 1
                }
                topPadding: -mRecord_tbview.contentY
                z: 2
                clip: true
                // spacing: 1
            }

            // horizon header
            Item {
                id: header_horizontal

                anchors{
                    left: parent.left
                    right: parent.right
                    leftMargin: mRecordTable.verHeaderWidth
                }
                height: mRecordTable.horHeaderHeight
                z: 2
                //暂存鼠标拖动的位置
                property int posXTemp: 0
                MouseArea{
                    anchors.fill: parent
                    onPressed: header_horizontal.posXTemp=mouseX;
                    onPositionChanged: {
                        if (mRecord_tbview.contentX + (header_horizontal.posXTemp-mouseX)>0) {
                            mRecord_tbview.contentX += (header_horizontal.posXTemp-mouseX);
                        } else {
                            mRecord_tbview.contentX=0;
                        }
                        header_horizontal.posXTemp=mouseX;
                    }
                }

                Row {
                    id: header_horizontal_row
                    anchors.fill: parent
                    leftPadding: -mRecord_tbview.contentX
                    clip: true
                    spacing: 0
        
                    Repeater {
                        model: mRecord_tbview.columns > 0 ? mRecord_tbview.columns : 0
        
                        Rectangle {
                            id: reagent_header_horizontal
                            width: mRecord_tbview.columnWidthProvider(index)+mRecord_tbview.columnSpacing
                            height: mRecordTable.horHeaderHeight

                            Rectangle {
                                id: headerItemBg
                                height: mRecordTable.horHeaderHeight
                                anchors.fill: parent

                                Canvas {
                                    implicitWidth: reagent_header_horizontal.width;
                                    implicitHeight: mRecordTable.horHeaderHeight;
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
                                text: machineRecordModel.headerData(index, Qt.Horizontal)
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
                                    mRecordTable.columnWidthArr[index]=(reagent_header_horizontal.width-mRecord_tbview.columnSpacing);
                                    //刷新布局，这样宽度才会改变
                                    mRecord_tbview.forceLayout();
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: popup
        width: 600
        height: 400
        color: "transparent"
        visible: false

        anchors.centerIn: parent

        property ListModel model: ListModel {
                id: imgModel
                ListElement { source: "file:///E:/data/captures_468_2/flat_000_003.jpg" }
                ListElement { source: "file:///E:/data/captures_468_2/flat_000_004.jpg" }
                ListElement { source: "file:///E:/data/captures_468_2/flat_000_005.jpg" }
            }
        property int itemCount: 5

        PathView{
            id: pathView
            model: popup.model
            delegate: Item {
                id:delegateItem
                width: 200
                height: 200
                z: PathView.iconZ
                scale: PathView.iconScale

                Image{
                    id:image
                    source: model.source
                    width: delegateItem.width
                    height: delegateItem.height
                }
                ShaderEffect {
                    anchors.top: image.bottom
                    width: image.width
                    height: image.height;
                    anchors.left: image.left
                    property variant source: image;
                    property size sourceSize: Qt.size(0.5 / image.width, 0.5 / image.height);
                    fragmentShader:
                            "varying highp vec2 qt_TexCoord0;
                            uniform lowp sampler2D source;
                            uniform lowp vec2 sourceSize;
                            uniform lowp float qt_Opacity;
                            void main() {

                                lowp vec2 tc = qt_TexCoord0 * vec2(1, -1) + vec2(0, 1);
                                lowp vec4 col = 0.25 * (texture2D(source, tc + sourceSize) + texture2D(source, tc- sourceSize)
                                + texture2D(source, tc + sourceSize * vec2(1, -1))
                                + texture2D(source, tc + sourceSize * vec2(-1, 1)));
                                gl_FragColor = col * qt_Opacity * (1.0 - qt_TexCoord0.y) * 0.2;
                            }"
                }

                transform: Rotation{
                    origin.x:image.width/2.0
                    origin.y:image.height/2.0
                    axis{x:0;y:1;z:0}
                    angle: delegateItem.PathView.iconAngle
                }
            }
            path:coverFlowPath
            pathItemCount: popup.itemCount
            anchors.fill: parent

            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5

        }

        Path{
            id:coverFlowPath
            startX: 0
            startY: popup.height/3

            PathAttribute{name:"iconZ";value: 0}
            PathAttribute{name:"iconAngle";value: 70}
            PathAttribute{name:"iconScale";value: 0.6}
            PathLine{x:popup.width/2;y:popup.height/3}

            PathAttribute{name:"iconZ";value: 100}
            PathAttribute{name:"iconAngle";value: 0}
            PathAttribute{name:"iconScale";value: 1.0}

            PathLine{x:popup.width;y:popup.height/3}
            PathAttribute{name:"iconZ";value: 0}
            PathAttribute{name:"iconAngle";value: -70}
            PathAttribute{name:"iconScale";value: 0.6}
            PathPercent{value:1.0}

        }

        // MouseArea {
        //     anchors.fill: parent
        //     onClicked: {
        //         popup.visible = false;
        //     }
        // }
    }

    Component.onCompleted: {
    }
}