# This Python file uses the following encoding: utf-8
import sys
import os

from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle
from mainWindow import MainWindow

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Get Context
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    # Set App Extra Info
    app.setOrganizationName("华南地区总经理")
    app.setOrganizationDomain("大中华区")

    # Set Icon
    app.setWindowIcon(QIcon("images/icon.ico"))
    QQuickStyle.setStyle("Fusion")
    engine.addImportPath(os.path.dirname(__file__))
    engine.addImportPath("qrc:/")
    # Load Initial Window
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
