# This Python file uses the following encoding: utf-8
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal, QTimer, QUrl

class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)
        pass
