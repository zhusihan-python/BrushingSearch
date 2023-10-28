import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Dialogs
import Qt.labs.qmlmodels 1.0
import "../components"

Item {
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
        }
    }
}