import QtQuick 6.6
import QtQuick.Window 6.6
import Qt5Compat.GraphicalEffects
import QtQuick.Timeline 1.0
import QtQuick.Controls 6.6
import QtQuick.Layouts 1.15
import "components"
import "pages"

Window {
    width: 1960
    height: 1020
    minimumWidth: 1100
    minimumHeight: 650
    visible: true
    color: "#00000000"
    id: mainWindow
    title: qsTr("WM BANK")

    // Remove title bar
    flags: Qt.Window | Qt.FramelessWindowHint

    // Text Edit Properties
    property alias actualPage: stackView.currentItem
    property bool isValueVisible: true
    property int windowStatus: 0
    property int windowMargin: 10
    property int bgRadius: 20

    // Internal functions
    QtObject{
        id: internal

        function resetResizeBorders(){
            // Resize visibility
            resizeLeft.visible = true
            resizeRight.visible = true
            resizeBottom.visible = true
            resizeApp.visible = true
            bg.radius = bgRadius
            bg.border.width = 3
        }

        function maximizeRestore(){
            if(windowStatus == 0){
                mainWindow.showMaximized()
                windowStatus = 1
                windowMargin = 0
                // Resize visibility
                resizeLeft.visible = false
                resizeRight.visible = false
                resizeBottom.visible = false
                resizeApp.visible = false
                bg.radius = 0
                bg.border.width = 0
                btnMaximizeRestore.btnIconSource = "../images/svg_images/restore_icon.svg"
            }
            else{
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                // Resize visibility
                internal.resetResizeBorders()
                bg.border.width = 3
                btnMaximizeRestore.btnIconSource = "../images/svg_images/maximize_icon.svg"
            }
        }

        function ifMaximizedWindowRestore(){
            if(windowStatus == 1){
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                // Resize visibility
                internal.resetResizeBorders()
                bg.border.width = 3
                btnMaximizeRestore.btnIconSource = "../images/svg_images/maximize_icon.svg"
            }
        }

        function restoreMargins(){
            windowStatus = 0
            windowMargin = 10
            bg.radius = bgRadius
            // Resize visibility
            internal.resetResizeBorders()
            bg.border.width = 3
            btnMaximizeRestore.btnIconSource = "../images/svg_images/maximize_icon.svg"
        }
    }

    Rectangle {
        id: bg
        opacity: 0
        color: "#1d1d2b"
        radius: 20
        border.color: "#33334c"
        border.width: 3
        anchors.fill: parent
        anchors.margins: windowMargin
        clip: true
        z: 1

        TopBarButton {
            id: btnClose
            x: 1140
            visible: true
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 8
            btnColorClicked: "#55aaff"
            btnColorMouseOver: "#ff007f"
            anchors.topMargin: 8
            btnIconSource: "../images/svg_images/close_icon.svg"
            CustomToolTip {
                text: "Sair"
            }
            onPressed: mainWindow.close()
        }

        TopBarButton {
            id: btnMaximizeRestore
            x: 1105
            visible: true
            anchors.right: btnClose.left
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.topMargin: 8
            btnColorMouseOver: "#40405f"
            btnColorClicked: "#55aaff"
            btnIconSource: "../images/svg_images/maximize_icon.svg"
            CustomToolTip {
                text: "Maximizar"
            }
            onClicked: internal.maximizeRestore()
        }

        TopBarButton {
            id: btnMinimize
            x: 1070
            visible: true
            anchors.right: btnMaximizeRestore.left
            anchors.top: parent.top
            btnRadius: 17
            anchors.rightMargin: 0
            btnColorClicked: "#55aaff"
            btnColorMouseOver: "#40405f"
            anchors.topMargin: 8
            btnIconSource: "../images/svg_images/minimize_icon.svg"
            CustomToolTip {
                text: "Minimizar"
            }
            onClicked: {
                mainWindow.showMinimized()
                internal.restoreMargins()
            }
        }

        Rectangle {
            id: titleBar
            height: 40
            color: "#33334c"
            radius: 14
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 120
            anchors.leftMargin: 8
            anchors.topMargin: 8

            DragHandler { onActiveChanged: if(active){
                   mainWindow.startSystemMove()
                   internal.ifMaximizedWindowRestore()
                }
            }

            Image {
                id: iconTopLogo
                y: 5
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                source: "../images/images/logo_white_30x30.png"
                sourceSize.height: 20
                sourceSize.width: 20
                anchors.leftMargin: 15
                fillMode: Image.PreserveAspectFit
            }

            Label {
                id: labelTitleBar
                y: 14
                color: "#ffffff"
                text: qsTr("大中华区 华南总经理")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: iconTopLogo.right
                font.pointSize: 12
                font.family: "Segoe UI"
                anchors.leftMargin: 15
            }
        }

        Column {
            id: columnCircularButtons
            width: 50
            anchors.left: parent.left
            anchors.top: titleBar.bottom
            anchors.bottom: parent.bottom
            spacing: 5
            anchors.bottomMargin: 10
            anchors.topMargin: 10
            anchors.leftMargin: 15

            CustomCircularButton {
                id: btnHome
                width: 50
                height: 50
                visible: true
                CustomToolTip {
                    text: "酒店查找"
                }
                btnIconSource: "../images/svg_images/search.svg"
                onClicked: {
                    stackView.push(Qt.resolvedUrl("pages/homePage.qml"))
                    // actualPage.showValue = isValueVisible
                }
            }
            CustomCircularButton {
                id: btnSettings
                width: 50
                height: 50
                visible: true
                CustomToolTip {
                    id: settingsTooltip
                    text: "数据导入"
                }
                btnIconSource: "../images/svg_images/database.svg"
                onClicked: {
                    stackView.push(Qt.resolvedUrl("pages/recordPage.qml"))
                }
            }
            CustomCircularButton {
                id: btnShowHide
                visible: true
                width: 50
                height: 50
                CustomToolTip {
                    text: "酒店导入"
                }
                btnIconSource: "../images/svg_images/home_icon.svg"
                onClicked: {
                    stackView.push(Qt.resolvedUrl("pages/hotelPage.qml"))
                }
            }
            CustomCircularButton {
                id: telphoneEdit
                visible: true
                width: 50
                height: 50
                CustomToolTip {
                    text: "手机号导入"
                }
                btnIconSource: "../images/svg_images/phone.svg"
                onClicked: {
                    stackView.push(Qt.resolvedUrl("pages/machinePage.qml"))
                }
            }
        }

        Rectangle {
            id: leftMenu
            width: 0
            color: "#00000000"
            border.color: "#00000000"
            border.width: 0
            anchors.left: columnCircularButtons.right
            anchors.top: titleBar.bottom
            anchors.bottom: parent.bottom
            clip: true
            anchors.bottomMargin: 10
            anchors.leftMargin: 5
            anchors.topMargin: 10

            PropertyAnimation{
                id: animationMenu
                target: leftMenu
                property: "width"
                to: if(leftMenu.width == 0) return 240; else return 0
                duration: 800
                easing.type: Easing.InOutQuint
            }

            Image {
                id: imageQrCode
                width: 110
                height: 110
                source: "../images/svg_images/qr-code.svg"
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.width: 110
                sourceSize.height: 110
            }

            Label {
                id: labelContaInfo
                x: 39
                opacity: 1
                color: "#55aaff"
                text: "WM BANK - BY: WANDERSON"
                anchors.top: imageQrCode.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                textFormat: Text.RichText
                anchors.horizontalCenterOffset: 0
                font.family: "Segoe UI"
                anchors.topMargin: 10
                font.bold: false
                font.weight: Font.Normal
                font.pointSize: 8
            }

            Column {
                id: columnMenus
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: labelContaInfo.bottom
                anchors.bottom: parent.bottom
                LeftButton {
                    text: "Help"
                    onClicked: stackView.push("pages/pageNoInternet.qml")
                }

                LeftButton {
                    text: "Profile"
                    btnIconSource: "../images/svg_images/user_icon.svg"
                    onClicked: stackView.push("pages/pageNoInternet.qml")
                }

                LeftButton {
                    text: "Settings"
                    btnIconSource: "../images/svg_images/moeda_icon.svg"
                    onClicked: stackView.push("pages/pageNoInternet.qml")
                }

                LeftButton {
                    text: "Credit Card"
                    btnIconSource: "../images/svg_images/cart_icon.svg"
                    onClicked: stackView.push("pages/pageNoInternet.qml")
                }

                LeftButton {
                    text: "Business"
                    btnIconSource: "../images/svg_images/home_PJ_icon.svg"
                    onClicked: stackView.push("pages/pageNoInternet.qml")
                }

                LeftButton {
                    text: "Messages"
                    btnIconSource: "../images/svg_images/message_icon.svg"
                    onClicked: stackView.push("pages/pageNoInternet.qml")
                }
                anchors.topMargin: 10
            }

            CustomButton {
                width: 220
                height: 30
                text: "DESCONECTAR"
                anchors.bottom: parent.bottom
                colorPressed: "#55aaff"
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"
                anchors.bottomMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle {
            id: contentPages
            color: "#00000000"
            anchors.left: leftMenu.right
            anchors.right: parent.right
            anchors.top: titleBar.bottom
            anchors.bottom: parent.bottom
            anchors.rightMargin: 15
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10

            StackView {
                id: stackView
                anchors.fill: parent
                clip: true
                initialItem: Qt.resolvedUrl("pages/homePage.qml")
            }
        }

    }

    DropShadow{
        id: dropShadowBG
        opacity: 0
        anchors.fill: bg
        source: bg
        verticalOffset: 0
        horizontalOffset: 0
        radius: 10
        color: "#40000000"
        z: 0
    }


    MouseArea {
        id: resizeLeft
        width: 12
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.leftMargin: 0
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.LeftEdge) }
        }
    }

    MouseArea {
        id: resizeRight
        width: 12
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.bottomMargin: 25
        anchors.leftMargin: 6
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor
        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.RightEdge) }
        }
    }

    MouseArea {
        id: resizeBottom
        height: 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeVerCursor
        anchors.rightMargin: 25
        anchors.leftMargin: 15
        anchors.bottomMargin: 0
        DragHandler{
            target: null
            onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.BottomEdge) }
        }
    }

    MouseArea {
        id: resizeApp
        x: 1176
        y: 697
        width: 25
        height: 25
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        cursorShape: Qt.SizeFDiagCursor
        DragHandler{
            target: null
            onActiveChanged: if (active){
                                 mainWindow.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                             }
        }
    }

    Timeline {
        id: timeline
        animations: [
            TimelineAnimation {
                id: timelineAnimation
                running: true
                loops: 1
                duration: 1000
                to: 1000
                from: 0
            }
        ]
        endFrame: 1000
        enabled: true
        startFrame: 0

        KeyframeGroup {
            target: bg
            property: "opacity"
            Keyframe {
                frame: 949
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }

        KeyframeGroup {
            target: dropShadowBG
            property: "opacity"
            Keyframe {
                frame: 949
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }
        }
    }
}
