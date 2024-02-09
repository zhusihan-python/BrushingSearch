function showMessageBox(message, title) {
    let component = Qt.createComponent("../controls/MessageDialog.qml")
    if (component.status === Component.Ready) {
        let dialog = component.createObject(homePage)
        dialog.title = qsTr(title)
        dialog.text = message
        dialog.anchors.centerIn = homePage
        dialog.open()
    } else {
        console.error(component.errorString())
    }
}