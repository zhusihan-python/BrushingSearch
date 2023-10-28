import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.5
import QtQuick.Dialogs
import Qt.labs.qmlmodels 1.0
import "../components"

Item {
    Rectangle {
        anchors.fill: parent
        color: "#e6eef6"

        Row {
            id: hotelFilterRow
            height: 25
            spacing: 15

            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                leftMargin: 10
            }

            TextField {
                id: hotelNameTxt
                width: 200
                height: 25
                selectByMouse: true

                property int lengthLimit: 25
                property var listModel: ListModel {} // 数据模型
                background: Rectangle {
                    implicitWidth: 150; implicitHeight: 30
                    color: hotelNameTxt.enabled ? "white": "transparent"

                    border {
                        color: hotelNameTxt.focus ? "#21be2b": "grey"
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        item_pop.open();
                    }
                }

                onTextChanged: {
                    // 模糊搜索逻辑
                    if (length > lengthLimit) remove(lengthLimit, length);
                    hotelNameTxt.listModel.clear();
                    if (text) {
                        // 从数据源搜索过滤结果到listModel
                    }
                }

                Popup {
                    id: item_pop
                    y: hotelNameTxt.height
                    width: hotelNameTxt.width
                    height: 150

                    ListView {
                        id: listView
                        model: hotelNameTxt.listModel
                        height: parent.height
                        width: parent.width
                        
                        delegate: ItemDelegate {
                            text: model.text
                            width: parent.width
                            onClicked: {
                                hotelNameTxt.text = model.text
                                item_pop.close()
                            }
                        }
                    }
                }
            }

            CustomButton {
                id: historyRecentWeekBtn
                text: qsTr("查询")
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"

                width: 100
                height: 25
            }

            Label {
                id: paltformLabel
                width: 60
                height: 25
                text: "APP平台："
                font.bold: true
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
            }

            ComboBox {
                id: paltformSelector
                width: 150
                height: 25
                model: platformCombo
                textRole: "display"
            }
        }

        Rectangle {
            id: hotelContent
            width: 1020
            color: "transparent"

            anchors {
                top: hotelFilterRow.bottom
                topMargin: 10
                left: parent.left
                leftMargin: 10
                bottom: parent.bottom
                bottomMargin: 10
            }

            RowLayout {
                spacing: 20
                Rectangle {
                    width: 500
                    height: parent.height
                    Column {
                        anchors.fill: parent
                        spacing: 5
                        Label {
                            width: 60
                            height: 25
                            text: "已做过："
                            font.bold: true
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter
                        }

                        Rectangle {
                            id: leftShowArea
                            width: parent.width
                            height: 800

                            Component {
                                id: doHighlight

                                Rectangle {
                                    width: 460; height: 30
                                    color: "lightsteelblue"; radius: 5
                                    y: doList.currentItem !== null ? doList.currentItem.y : 0
                                    Behavior on y {
                                        SpringAnimation { spring:3; damping: 0.25 }
                                    }
                                }
                            }

                            ListView {
                                id: doList
                                anchors.fill: parent
                                anchors.margins: 10
                                model: ListModel {
                                    id: doChoice
                                    ListElement { text: "1号机" }
                                    ListElement { text: "2号机" }
                                    ListElement { text: "3号机" }
                                    ListElement { text: "4号机" }
                                    ListElement { text: "5号机" }
                                    ListElement { text: "6号机" }
                                    ListElement { text: "7号机" }
                                }
                                snapMode: ListView.SnapToItem
                                clip: true

                                delegate: Item {
                                        implicitWidth: 460; implicitHeight: 30

                                        Text {
                                            anchors {
                                                left: parent.left
                                                verticalCenter: parent.verticalCenter
                                            }
                                            text: model.text
                                            font.pointSize: 10
                                            horizontalAlignment: Text.AlignLeft
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                doList.currentIndex = index;
                                            }
                                        }
                                    }

                                highlight: doHighlight
                                highlightFollowsCurrentItem: false
                                focus: true
                                keyNavigationWraps: true

                                ScrollBar.vertical: ScrollBar {
                                    id: doControl
                                    size: 0.3
                                    width: 10
                                    policy: ScrollBar.AlwaysOn

                                    contentItem: Rectangle {
                                        implicitWidth: 3
                                        implicitHeight: 100
                                        radius: width / 2
                                        color: doControl.pressed ? "darkgrey" : "lightgrey"
                                        opacity: doControl.policy === ScrollBar.AlwaysOn || (doControl.active && doControl.size < 1.0) ? 0.75 : 0
                                    }
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    width: 500
                    height: parent.height

                    Column {
                        anchors.fill: parent
                        spacing: 5
                        Label {
                            width: 60
                            height: 25
                            text: "没做过："
                            font.bold: true
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter
                        }

                        Rectangle {
                            id: rightShowArea
                            width: parent.width
                            height: 800

                            Component {
                                id: undoHighlight

                                Rectangle {
                                    width: 460; height: 30
                                    color: "lightsteelblue"; radius: 5
                                    y: undoList.currentItem !== null ? undoList.currentItem.y : 0
                                    Behavior on y {
                                        SpringAnimation { spring:3; damping: 0.25 }
                                    }
                                }
                            }

                            ListView {
                                id: undoList
                                anchors.fill: parent
                                anchors.margins: 10
                                model: ListModel {
                                    id: undoChoice
                                    ListElement { text: "8号机" }
                                    ListElement { text: "9号机" }
                                    ListElement { text: "10号机" }
                                    ListElement { text: "11号机" }
                                    ListElement { text: "12号机" }
                                    ListElement { text: "13号机" }
                                    ListElement { text: "14号机" }
                                }
                                snapMode: ListView.SnapToItem
                                clip: true

                                delegate: Item {
                                        implicitWidth: 460; implicitHeight: 30

                                        Text {
                                            anchors {
                                                left: parent.left
                                                verticalCenter: parent.verticalCenter
                                            }
                                            text: model.text
                                            font.pointSize: 10
                                            horizontalAlignment: Text.AlignLeft
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                undoList.currentIndex = index;
                                            }
                                        }
                                    }

                                highlight: undoHighlight
                                highlightFollowsCurrentItem: false
                                focus: true
                                keyNavigationWraps: true

                                ScrollBar.vertical: ScrollBar {
                                    id: undoControl
                                    size: 0.3
                                    width: 10
                                    policy: ScrollBar.AlwaysOn

                                    contentItem: Rectangle {
                                        implicitWidth: 3
                                        implicitHeight: 100
                                        radius: width / 2
                                        color: undoControl.pressed ? "darkgrey" : "lightgrey"
                                        opacity: undoControl.policy === ScrollBar.AlwaysOn || (undoControl.active && undoControl.size < 1.0) ? 0.75 : 0
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}