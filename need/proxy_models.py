from PySide6.QtCore import QSortFilterProxyModel, Slot, Qt
from need.models import hotel_model


class HotelProxyModel(QSortFilterProxyModel):
    def __init__(self):
        super().__init__()
        self.setFilterCaseSensitivity(Qt.CaseInsensitive)
        self.setSourceModel(hotel_model)
        self.text_0 = ""

    @Slot()
    def set_name_role(self):
        self.filterRole = hotel_model.hotelName
        self.setFilterKeyColumn(0)

    @Slot(str)
    def setFilterText(self, t0):
        self.text_0 = t0
        self.setFilterRegularExpression("")

    # def filterAcceptsRow(self, sourceRow, sourceParent):
    #     index0 = self.sourceModel().index(sourceRow, 0, sourceParent)
    #     hotel_name = str(self.sourceModel().data(index0, Qt.DisplayRole))
    #     return hotel_name.__contains__(self.text_0)

hotel_proxy_model = HotelProxyModel()
